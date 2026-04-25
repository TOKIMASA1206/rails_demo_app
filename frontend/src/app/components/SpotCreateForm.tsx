"use client";

import { useState } from "react";

import type { Category } from "@/types/category";
import type { Spot, SpotFormValues } from "@/types/spot";

type SpotCreateFormProps = {
  categories: Category[];
  onCreated: (spot: Spot) => void;
};

type CreateSpotResponse = Spot | { errors?: string[] };

const initialValues: SpotFormValues = {
  category_id: "1",
  name: "",
  note: "",
  url: "",
  status: "want_to_go",
};

export function SpotCreateForm({ categories, onCreated }: SpotCreateFormProps) {
  const [values, setValues] = useState<SpotFormValues>(() => ({
    ...initialValues,
    category_id: categories[0]?.id.toString() ?? initialValues.category_id,
  }));
  const [error, setError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const updateValue = (field: keyof SpotFormValues, value: string) => {
    setValues((currentValues) => ({
      ...currentValues,
      [field]: value,
    }));
  };

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL;

    if (!apiBaseUrl) {
      setError("NEXT_PUBLIC_API_BASE_URL is not set");
      return;
    }

    setIsSubmitting(true);
    setError(null);

    try {
      const response = await fetch(`${apiBaseUrl}/api/spots`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-User-Id": "1",
        },
        body: JSON.stringify({
          spot: {
            category_id: Number(values.category_id),
            name: values.name,
            note: values.note,
            url: values.url,
            status: values.status,
          },
        }),
      });

      const data = (await response.json()) as CreateSpotResponse;

      if (!response.ok) {
        throw new Error(
          "errors" in data && Array.isArray(data.errors)
            ? data.errors.join(", ")
            : `HTTP ${response.status}`,
        );
      }

      onCreated(data as Spot);
      setValues({
        ...initialValues,
        category_id: categories[0]?.id.toString() ?? initialValues.category_id,
      });
    } catch (submitError) {
      setError(
        submitError instanceof Error
          ? submitError.message
          : "Unknown error occurred",
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="rounded-lg border border-zinc-200 bg-white p-5 shadow-sm"
    >
      <div className="space-y-5">
        <div className="space-y-1">
          <h2 className="text-xl font-semibold text-zinc-900">
            スポットを追加
          </h2>
          <p className="text-sm text-zinc-600">
            行きたい場所や訪問済みの場所を保存します。
          </p>
        </div>

        <div className="grid gap-4">
          <div>
            <label
              htmlFor="spot-name"
              className="block text-sm font-medium text-zinc-700"
            >
              名前
            </label>
            <input
              id="spot-name"
              value={values.name}
              onChange={(event) => updateValue("name", event.target.value)}
              className="mt-1 w-full rounded-md border border-zinc-300 px-3 py-2 text-sm text-zinc-900 shadow-sm focus:border-zinc-500 focus:outline-none focus:ring-2 focus:ring-zinc-200"
            />
          </div>

          <div>
            <label
              htmlFor="spot-note"
              className="block text-sm font-medium text-zinc-700"
            >
              メモ
            </label>
            <textarea
              id="spot-note"
              value={values.note}
              onChange={(event) => updateValue("note", event.target.value)}
              className="mt-1 min-h-20 w-full rounded-md border border-zinc-300 px-3 py-2 text-sm text-zinc-900 shadow-sm focus:border-zinc-500 focus:outline-none focus:ring-2 focus:ring-zinc-200"
            />
          </div>

          <div>
            <label
              htmlFor="spot-url"
              className="block text-sm font-medium text-zinc-700"
            >
              URL
            </label>
            <input
              id="spot-url"
              type="url"
              value={values.url}
              onChange={(event) => updateValue("url", event.target.value)}
              className="mt-1 w-full rounded-md border border-zinc-300 px-3 py-2 text-sm text-zinc-900 shadow-sm focus:border-zinc-500 focus:outline-none focus:ring-2 focus:ring-zinc-200"
            />
          </div>

          <div className="grid gap-4 sm:grid-cols-2">
            <div>
              <label
                htmlFor="spot-status"
                className="block text-sm font-medium text-zinc-700"
              >
                ステータス
              </label>
              <select
                id="spot-status"
                value={values.status}
                onChange={(event) => updateValue("status", event.target.value)}
                className="mt-1 w-full rounded-md border border-zinc-300 bg-white px-3 py-2 text-sm text-zinc-900 shadow-sm focus:border-zinc-500 focus:outline-none focus:ring-2 focus:ring-zinc-200"
              >
                <option value="want_to_go">行きたい</option>
                <option value="visited">訪問済み</option>
              </select>
            </div>

            <div>
              <label
                htmlFor="spot-category-id"
                className="block text-sm font-medium text-zinc-700"
              >
                カテゴリー
              </label>
              <select
                id="spot-category-id"
                disabled={categories.length === 0}
                value={values.category_id}
                onChange={(event) =>
                  updateValue("category_id", event.target.value)
                }
                className="mt-1 w-full rounded-md border border-zinc-300 bg-white px-3 py-2 text-sm text-zinc-900 shadow-sm focus:border-zinc-500 focus:outline-none focus:ring-2 focus:ring-zinc-200 disabled:cursor-not-allowed disabled:bg-zinc-100"
              >
                {categories.length === 0 ? (
                  <option value="">カテゴリーがありません</option>
                ) : (
                  categories.map((category) => (
                    <option key={category.id} value={category.id}>
                      {category.name}
                    </option>
                  ))
                )}
              </select>
            </div>
          </div>
        </div>

        {error && (
          <p className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
          </p>
        )}

        <button
          type="submit"
          disabled={isSubmitting}
          className="rounded-md bg-zinc-900 px-4 py-2 text-sm font-medium text-white shadow-sm disabled:cursor-not-allowed disabled:bg-zinc-400"
        >
          {isSubmitting ? "保存中..." : "保存する"}
        </button>
      </div>
    </form>
  );
}
