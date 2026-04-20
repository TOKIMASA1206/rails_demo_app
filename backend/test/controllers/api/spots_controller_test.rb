require "test_helper"

class Api::SpotsControllerTest < ActionDispatch::IntegrationTest
  SPOT_RESPONSE_KEYS = %w[
    id
    category_id
    user_id
    name
    note
    url
    status
    visited_on
    created_at
    updated_at
  ].freeze

  test "lists spots" do
    get "/api/spots"

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal 2, response_json.length
    assert_equal [ spots(:one).id, spots(:two).id ].sort, response_json.map { |spot| spot["id"] }.sort
    assert_equal SPOT_RESPONSE_KEYS.sort, response_json.first.keys.sort
  end

  test "filters spots by category_id" do
    get "/api/spots", params: { category_id: categories(:one).id }

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal 1, response_json.length
    assert_equal [ spots(:one).id ], response_json.map { |spot| spot["id"] }
    assert_equal SPOT_RESPONSE_KEYS.sort, response_json.first.keys.sort
  end

  test "returns an empty array when no spots match the category filter" do
    get "/api/spots", params: { category_id: 999999 }

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal [], response_json
  end

  test "sorts spots by name in ascending order" do
    spot_c = Spot.create!(
      user: users(:one),
      category: categories(:one),
      name: "Zebra Cafe",
      status: "want_to_go"
    )
    spot_a = Spot.create!(
      user: users(:one),
      category: categories(:one),
      name: "Apple Cafe",
      status: "want_to_go"
    )

    get "/api/spots", params: { sort: "name_asc" }

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal [ spot_a.id, spots(:one).id, spots(:two).id, spot_c.id ], response_json.map { |spot| spot["id"] }
    assert_equal SPOT_RESPONSE_KEYS.sort, response_json.first.keys.sort
  end

  test "sorts spots by created_at in descending order" do
    older_spot = Spot.create!(
      user: users(:one),
      category: categories(:one),
      name: "Older Cafe",
      status: "want_to_go",
      created_at: 2.days.ago,
      updated_at: 2.days.ago
    )
    newer_spot = Spot.create!(
      user: users(:one),
      category: categories(:one),
      name: "Newer Cafe",
      status: "want_to_go",
      created_at: 1.hour.ago,
      updated_at: 1.hour.ago
    )

    get "/api/spots", params: { sort: "created_at_desc" }

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_operator response_json.map { |spot| spot["id"] }.index(newer_spot.id), :<, response_json.map { |spot| spot["id"] }.index(older_spot.id)
  end

  test "returns bad request when sort parameter is invalid" do
    get "/api/spots", params: { sort: "name_desc" }

    assert_response :bad_request

    response_json = JSON.parse(response.body)

    assert_equal [ "Invalid sort parameter" ], response_json["errors"]
  end

  test "creates a spot" do
    assert_difference("Spot.count", 1) do
      post "/api/spots",
        params: {
          spot: {
            category_id: categories(:one).id,
            name: "Local Sento",
            note: "Open late",
            url: "https://example.com/sento",
            status: "want_to_go",
            visited_on: "2026-04-09"
          }
        },
        headers: auth_headers(users(:one)),
        as: :json
    end

    assert_response :created

    response_json = JSON.parse(response.body)

    assert_equal "Local Sento", response_json["name"]
    assert_equal "want_to_go", response_json["status"]
    assert_equal categories(:one).id, response_json["category_id"]
    assert_equal users(:one).id, response_json["user_id"]
    assert_equal SPOT_RESPONSE_KEYS.sort, response_json.keys.sort
  end

  test "shows a spot" do
    get "/api/spots/#{spots(:one).id}"

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal spots(:one).id, response_json["id"]
    assert_equal spots(:one).name, response_json["name"]
    assert_equal spots(:one).status, response_json["status"]
    assert_equal spots(:one).user_id, response_json["user_id"]
    assert_equal SPOT_RESPONSE_KEYS.sort, response_json.keys.sort
  end

  test "returns not found when spot does not exist" do
    get "/api/spots/999999"

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal [ "Spot not found" ], response_json["errors"]
  end

  test "updates a spot" do
    patch "/api/spots/#{spots(:one).id}",
      params: {
        spot: {
          name: "Updated Cafe",
          status: "visited"
        }
      },
      headers: auth_headers(users(:one)),
      as: :json

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal "Updated Cafe", response_json["name"]
    assert_equal "visited", response_json["status"]
    assert_equal spots(:one).user_id, response_json["user_id"]
    assert_equal SPOT_RESPONSE_KEYS.sort, response_json.keys.sort
    assert_equal "Updated Cafe", spots(:one).reload.name
    assert_equal "visited", spots(:one).reload.status
  end

  test "returns unauthorized when updating without authentication" do
    original_name = spots(:one).name

    patch "/api/spots/#{spots(:one).id}",
      params: {
        spot: {
          name: "Updated Cafe"
        }
      },
      as: :json

    assert_response :unauthorized

    response_json = JSON.parse(response.body)

    assert_equal [ "Unauthorized" ], response_json["errors"]
    assert_equal original_name, spots(:one).reload.name
  end

  test "returns forbidden when updating another user's spot" do
    original_name = spots(:two).name

    patch "/api/spots/#{spots(:two).id}",
      params: {
        spot: {
          name: "Hijacked Spot"
        }
      },
      headers: auth_headers(users(:one)),
      as: :json

    assert_response :forbidden

    response_json = JSON.parse(response.body)

    assert_equal [ "Forbidden" ], response_json["errors"]
    assert_equal original_name, spots(:two).reload.name
  end

  test "returns not found when updating a non-existent spot" do
    patch "/api/spots/999999",
      params: {
        spot: {
          name: "Updated Cafe"
        }
      },
      headers: auth_headers(users(:one)),
      as: :json

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal [ "Spot not found" ], response_json["errors"]
  end

  test "destroys a spot" do
    assert_difference("Spot.count", -1) do
      delete "/api/spots/#{spots(:one).id}",
        headers: auth_headers(users(:one))
    end

    assert_response :no_content
  end

  test "returns unauthorized when deleting without authentication" do
    assert_no_difference("Spot.count") do
      delete "/api/spots/#{spots(:one).id}"
    end

    assert_response :unauthorized

    response_json = JSON.parse(response.body)

    assert_equal [ "Unauthorized" ], response_json["errors"]
  end

  test "returns forbidden when deleting another user's spot" do
    assert_no_difference("Spot.count") do
      delete "/api/spots/#{spots(:two).id}",
        headers: auth_headers(users(:one))
    end

    assert_response :forbidden

    response_json = JSON.parse(response.body)

    assert_equal [ "Forbidden" ], response_json["errors"]
  end

  test "returns not found when deleting a non-existent spot" do
    assert_no_difference("Spot.count") do
      delete "/api/spots/999999",
        headers: auth_headers(users(:one))
    end

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal [ "Spot not found" ], response_json["errors"]
  end

  test "returns errors when spot is invalid" do
    assert_no_difference("Spot.count") do
      post "/api/spots",
        params: {
          spot: {
            category_id: categories(:one).id,
            name: "",
            status: "want_to_go"
          }
        },
        headers: auth_headers(users(:one)),
        as: :json
    end

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_includes response_json["errors"], "Name can't be blank"
  end

  test "returns errors when spot status is unsupported" do
    assert_no_difference("Spot.count") do
      post "/api/spots",
        params: {
          spot: {
            category_id: categories(:one).id,
            name: "Test Spot",
            status: "archived"
          }
        },
        headers: auth_headers(users(:one)),
        as: :json
    end

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_includes response_json["errors"], "Status is not included in the list"
  end

  test "returns errors when category does not exist" do
    assert_no_difference("Spot.count") do
      post "/api/spots",
        params: {
          spot: {
            category_id: -1,
            name: "Ghost Spot",
            status: "want_to_go"
          }
        },
        headers: auth_headers(users(:one)),
        as: :json
    end

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_includes response_json["errors"], "Category must exist"
  end

  test "returns unauthorized when user does not exist" do
    assert_no_difference("Spot.count") do
      post "/api/spots",
        params: {
          spot: {
            category_id: categories(:one).id,
            name: "Ghost Spot",
            status: "want_to_go"
          }
        },
        headers: { "X-User-Id" => "-1" },
        as: :json
    end

    assert_response :unauthorized

    response_json = JSON.parse(response.body)

    assert_equal [ "Unauthorized" ], response_json["errors"]
  end

  test "returns unauthorized when user header is missing" do
    assert_no_difference("Spot.count") do
      post "/api/spots",
        params: {
          spot: {
            category_id: categories(:one).id,
            name: "No Owner Spot",
            status: "want_to_go"
          }
        },
        as: :json
    end

    assert_response :unauthorized

    response_json = JSON.parse(response.body)

    assert_equal [ "Unauthorized" ], response_json["errors"]
  end

  test "uses current_user instead of request user_id" do
    assert_difference("Spot.count", 1) do
      post "/api/spots",
        params: {
          spot: {
            user_id: users(:two).id,
            category_id: categories(:one).id,
            name: "Header Owned Spot",
            status: "want_to_go"
          }
        },
        headers: auth_headers(users(:one)),
        as: :json
    end

    assert_response :created

    response_json = JSON.parse(response.body)

    assert_equal users(:one).id, response_json["user_id"]
    assert_equal users(:one).id, Spot.find(response_json["id"]).user_id
  end

  private

  def auth_headers(user)
    { "X-User-Id" => user.id.to_s }
  end
end
