"use client";

import { useEffect, useState } from "react";

import type { Category } from "@/types/category";
import type { Spot } from "@/types/spot";

import { SpotCreateForm } from "./SpotCreateForm";

type FetchState =
  | { status: "loading" }
  | { status: "success"; categoriesState: CategoriesState; spots: Spot[] }
  | { status: "error"; message: string };

type CategoriesState =
  | { status: "success"; categories: Category[] }
  | { status: "error"; message: string };

type SpotsListMessageProps = {
  tone?: "default" | "error";
  children: React.ReactNode;
};

type SpotListItemProps = {
  categories: Category[];
  spot: Spot;
};

type SpotsListContentProps = {
  categoriesState: CategoriesState;
  spots: Spot[];
  onSpotCreated: (spot: Spot) => void;
};

function formatSpotStatus(status: Spot["status"]) {
  switch (status) {
    case "want_to_go":
      return "行きたい";
    case "visited":
      return "訪問済み";
  }
}

function findCategoryName(categories: Category[], categoryId: number) {
  return categories.find((category) => category.id === categoryId)?.name;
}

function safeHttpUrl(url: string | null) {
  if (!url) return null;

  try {
    const parsedUrl = new URL(url);
    return parsedUrl.protocol === "http:" || parsedUrl.protocol === "https:"
      ? parsedUrl.toString()
      : null;
  } catch {
    return null;
  }
}

async function fetchCategories(apiBaseUrl: string): Promise<CategoriesState> {
  try {
    const response = await fetch(`${apiBaseUrl}/api/categories`);

    if (!response.ok) {
      return {
        status: "error",
        message: `Categories HTTP ${response.status}`,
      };
    }

    const categories: Category[] = await response.json();
    return { status: "success", categories };
  } catch (error) {
    return {
      status: "error",
      message: error instanceof Error ? error.message : "Unknown error occurred",
    };
  }
}

function SpotsListMessage({ tone = "default", children }: SpotsListMessageProps) {
  const isError = tone === "error";

  return (
    <section
      className={`rounded-lg border p-5 shadow-sm ${
        isError ? "border-red-200 bg-red-50" : "border-zinc-200 bg-white"
      }`}
    >
      <h2
        className={`text-xl font-semibold ${
          isError ? "text-red-900" : "text-zinc-900"
        }`}
      >
        保存したスポット
      </h2>
      <p className={`mt-3 text-sm ${isError ? "text-red-700" : "text-zinc-600"}`}>
        {children}
      </p>
    </section>
  );
}

function SpotListItem({ categories, spot }: SpotListItemProps) {
  const categoryName = findCategoryName(categories, spot.category_id);
  const safeUrl = safeHttpUrl(spot.url);

  return (
    <li className="rounded-lg border border-zinc-200 bg-white p-4 shadow-sm">
      <div className="space-y-2">
        <div className="flex items-start justify-between gap-3">
          <h3 className="text-lg font-medium text-zinc-900">{spot.name}</h3>
          <span className="rounded-full bg-zinc-100 px-3 py-1 text-xs font-medium text-zinc-700">
            {formatSpotStatus(spot.status)}
          </span>
        </div>

        <p className="text-sm text-zinc-500">
          カテゴリー: {categoryName ?? `ID ${spot.category_id}`}
        </p>

        {spot.note && (
          <p className="text-sm text-zinc-600">メモ: {spot.note}</p>
        )}

        {safeUrl && (
          <a
            href={safeUrl}
            target="_blank"
            rel="noreferrer"
            className="inline-block text-sm font-medium text-zinc-700 underline underline-offset-2"
          >
            URLを見る
          </a>
        )}
      </div>
    </li>
  );
}

function SpotsListContent({
  categoriesState,
  spots,
  onSpotCreated,
}: SpotsListContentProps) {
  const categories =
    categoriesState.status === "success" ? categoriesState.categories : [];

  return (
    <section className="space-y-6">
      <SpotCreateForm
        categories={categories}
        categoryError={
          categoriesState.status === "error" ? categoriesState.message : undefined
        }
        onCreated={onSpotCreated}
      />

      <div className="space-y-1">
        <h2 className="text-xl font-semibold text-zinc-900">保存したスポット</h2>
        <p className="text-sm text-zinc-600">{spots.length} spots</p>
      </div>

      {spots.length === 0 ? (
        <div className="rounded-lg border border-zinc-200 bg-white p-5 text-sm text-zinc-600 shadow-sm">
          行きたい場所をまだ保存していません。
        </div>
      ) : (
        <ul className="space-y-3">
          {spots.map((spot) => (
            <SpotListItem key={spot.id} categories={categories} spot={spot} />
          ))}
        </ul>
      )}
    </section>
  );
}

export function SpotsList() {
  const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL;
  const [state, setState] = useState<FetchState>({ status: "loading" });

  useEffect(() => {
    if (!apiBaseUrl) return;

    let ignore = false;

    const fetchSpots = async () => {
      try {
        const [spotsResponse, categoriesState] = await Promise.all([
          fetch(`${apiBaseUrl}/api/spots`),
          fetchCategories(apiBaseUrl),
        ]);

        if (!spotsResponse.ok) {
          throw new Error(`Spots HTTP ${spotsResponse.status}`);
        }

        const spots: Spot[] = await spotsResponse.json();

        if (!ignore) {
          setState({ status: "success", categoriesState, spots });
        }
      } catch (error) {
        if (!ignore) {
          setState({
            status: "error",
            message:
              error instanceof Error ? error.message : "Unknown error occurred",
          });
        }
      }
    };

    fetchSpots();

    return () => {
      ignore = true;
    };
  }, [apiBaseUrl]);

  const handleSpotCreated = (spot: Spot) => {
    setState((currentState) => {
      if (currentState.status !== "success") {
        return currentState;
      }

      return {
        status: "success",
        categoriesState: currentState.categoriesState,
        spots: [spot, ...currentState.spots],
      };
    });
  };

  if (!apiBaseUrl) {
    return (
      <SpotsListMessage tone="error">
        API error: NEXT_PUBLIC_API_BASE_URL is not set
      </SpotsListMessage>
    );
  }

  if (state.status === "loading") {
    return <SpotsListMessage>スポットを読み込み中です...</SpotsListMessage>;
  }

  if (state.status === "error") {
    return (
      <SpotsListMessage tone="error">
        スポットの取得に失敗しました: {state.message}
      </SpotsListMessage>
    );
  }

  return (
    <SpotsListContent
      categoriesState={state.categoriesState}
      spots={state.spots}
      onSpotCreated={handleSpotCreated}
    />
  );
}
