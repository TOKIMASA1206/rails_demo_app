export type SpotStatus = "want_to_go" | "visited";

export type Spot = {
  id: number;
  category_id: number;
  user_id: number;
  name: string;
  note: string | null;
  url: string | null;
  status: SpotStatus;
  visited_on: string | null;
  created_at: string;
  updated_at: string;
};

export type SpotFormValues = {
  category_id: string;
  name: string;
  note: string;
  url: string;
  status: SpotStatus;
};
