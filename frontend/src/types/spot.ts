export type Spot = {
  id: number;
  category_id: number;
  user_id: number;
  name: string;
  note: string | null;
  url: string | null;
  status: "want_to_go" | "visited";
  visited_on: string | null;
  created_at: string;
  updated_at: string;
};
