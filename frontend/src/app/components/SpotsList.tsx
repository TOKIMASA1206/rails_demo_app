"use client";

import { useEffect, useState } from "react";

import type { Spot } from "@/types/spot";

import { SpotCreateForm } from "./SpotCreateForm";

type FetchState =
  | { status: "loading" }
  | { status: "success"; spots: Spot[] }
  | { status: "error"; message: string };

type SpotsListMessageProps = {
  tone?: "default" | "error";
  children: React.ReactNode;
};

type SpotListItemProps = {
  spot: Spot;
};

type SpotsListContentProps = {
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

function SpotListItem({ spot }: SpotListItemProps) {
  return (
    <li className="rounded-lg border border-zinc-200 bg-white p-4 shadow-sm">
      <div className="space-y-2">
        <div className="flex items-start justify-between gap-3">
          <h3 className="text-lg font-medium text-zinc-900">{spot.name}</h3>
          <span className="rounded-full bg-zinc-100 px-3 py-1 text-xs font-medium text-zinc-700">
            {formatSpotStatus(spot.status)}
          </span>
        </div>

        <p className="text-sm text-zinc-500">Category ID: {spot.category_id}</p>
        <p className="text-sm text-zinc-500">Name: {spot.name}</p>
      </div>
    </li>
  );
}

function SpotsListContent({ spots, onSpotCreated }: SpotsListContentProps) {
  return (
    <section className="space-y-6">
      <SpotCreateForm onCreated={onSpotCreated} />

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
            <SpotListItem key={spot.id} spot={spot} />
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
        const response = await fetch(`${apiBaseUrl}/api/spots`);

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }

        const spots: Spot[] = await response.json();

        if (!ignore) {
          setState({ status: "success", spots });
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
      spots={state.spots}
      onSpotCreated={handleSpotCreated}
    />
  );
}
