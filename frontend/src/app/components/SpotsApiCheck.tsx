"use client";

import { useEffect, useState } from "react";

import type { Spot } from "@/types/spot";

type FetchState =
  | { status: "loading" }
  | { status: "success"; spots: Spot[] }
  | { status: "error"; message: string };

export function SpotsApiCheck() {
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
    return <p>API error: NEXT_PUBLIC_API_BASE_URL is not set</p>;
  }

  if (state.status === "loading") {
    return <p>Loading spots...</p>;
  }

  if (state.status === "error") {
    return <p>API error: {state.message}</p>;
  }

  return (
    <section>
      <h2>Spots API check</h2>
      <p>Loaded spots: {state.spots.length}</p>

      {state.spots.length > 0 && (
        <ul>
          {state.spots.map((spot) => (
            <li key={spot.id}>
              {spot.name} ({spot.status})
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
