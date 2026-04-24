import { SpotsList } from "./components/SpotsList";

export default function Home() {
  return (
    <main className="min-h-screen bg-zinc-50 px-6 py-10">
      <div className="mx-auto w-full max-w-3xl space-y-8">
        <header className="space-y-2">
          <h1 className="text-3xl font-bold text-zinc-950">SpotLog</h1>
          <p className="text-sm text-zinc-600">保存したスポットの一覧</p>
        </header>

        <SpotsList />
      </div>
    </main>
  );
}
