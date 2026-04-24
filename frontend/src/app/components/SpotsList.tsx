"use client";

import { useEffect, useState } from "react";

import type { Spot } from "@/types/spot";

type FetchState =
  | { status: "loading" }
  | { status: "success"; spots: Spot[] }
  | { status: "error"; message: string };

function formatSpotStatus(status: Spot["status"]) {
  switch (status) {
    case "want_to_go":
      return "行きたい";
    case "visited":
      return "訪問済み";
  }
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

  if (!apiBaseUrl) {
    return (
      <section className="rounded-lg border border-red-200 bg-red-50 p-5 shadow-sm">
        <h2 className="text-xl font-semibold text-red-900">保存したスポット</h2>
        <p className="mt-3 text-sm text-red-700">
          API error: NEXT_PUBLIC_API_BASE_URL is not set
        </p>
      </section>
    );
  }

  if (state.status === "loading") {
    return (
      <section className="rounded-lg border border-zinc-200 bg-white p-5 shadow-sm">
        <h2 className="text-xl font-semibold text-zinc-900">保存したスポット</h2>
        <p className="mt-3 text-sm text-zinc-600">スポットを読み込み中です...</p>
      </section>
    );
  }

  if (state.status === "error") {
    return (
      <section className="rounded-lg border border-red-200 bg-red-50 p-5 shadow-sm">
        <h2 className="text-xl font-semibold text-red-900">保存したスポット</h2>
        <p className="mt-3 text-sm text-red-700">
          スポットの取得に失敗しました: {state.message}
        </p>
      </section>
    );
  }

  if (state.spots.length === 0) {
    return (
      <section className="rounded-lg border border-zinc-200 bg-white p-5 shadow-sm">
        <h2 className="text-xl font-semibold text-zinc-900">保存したスポット</h2>
        <p className="mt-2 text-sm text-zinc-600">
          行きたい場所をまだ保存していません。
        </p>
      </section>
    );
  }

  return (
    <section className="space-y-4">
      <div className="space-y-1">
        <h2 className="text-xl font-semibold text-zinc-900">保存したスポット</h2>
        <p className="text-sm text-zinc-600">{state.spots.length} spots</p>
      </div>

      <ul className="space-y-3">
        {state.spots.map((spot) => (
          <li
            key={spot.id}
            className="rounded-lg border border-zinc-200 bg-white p-4 shadow-sm"
          >
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
        ))}
      </ul>
    </section>
  );
}
