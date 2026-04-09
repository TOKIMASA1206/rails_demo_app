require "test_helper"

class Api::SpotsControllerTest < ActionDispatch::IntegrationTest
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
        as: :json
    end

    assert_response :created

    response_json = JSON.parse(response.body)

    assert_equal "Local Sento", response_json["name"]
    assert_equal "want_to_go", response_json["status"]
    assert_equal categories(:one).id, response_json["category_id"]
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
        as: :json
    end

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_includes response_json["errors"], "Category must exist"
  end
end
