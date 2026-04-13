require "test_helper"

class Api::SpotsControllerTest < ActionDispatch::IntegrationTest
  test "lists spots" do
    get "/api/spots"

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal 2, response_json.length
    assert_equal [spots(:one).id, spots(:two).id].sort, response_json.map { |spot| spot["id"] }.sort
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
        as: :json
    end

    assert_response :created

    response_json = JSON.parse(response.body)

    assert_equal "Local Sento", response_json["name"]
    assert_equal "want_to_go", response_json["status"]
    assert_equal categories(:one).id, response_json["category_id"]
  end

  test "shows a spot" do
    get "/api/spots/#{spots(:one).id}"

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal spots(:one).id, response_json["id"]
    assert_equal spots(:one).name, response_json["name"]
    assert_equal spots(:one).status, response_json["status"]
  end

  test "returns not found when spot does not exist" do
    get "/api/spots/999999"

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal ["Spot not found"], response_json["errors"]
  end

  test "updates a spot" do
    patch "/api/spots/#{spots(:one).id}",
      params: {
        spot: {
          name: "Updated Cafe",
          status: "visited"
        }
      },
      as: :json

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal "Updated Cafe", response_json["name"]
    assert_equal "visited", response_json["status"]
    assert_equal "Updated Cafe", spots(:one).reload.name
    assert_equal "visited", spots(:one).reload.status
  end

  test "returns not found when updating a non-existent spot" do
    patch "/api/spots/999999",
      params: {
        spot: {
          name: "Updated Cafe"
        }
      },
      as: :json

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal ["Spot not found"], response_json["errors"]
  end

  test "destroys a spot" do
    assert_difference("Spot.count", -1) do
      delete "/api/spots/#{spots(:one).id}"
    end

    assert_response :no_content
  end

  test "returns not found when deleting a non-existent spot" do
    assert_no_difference("Spot.count") do
      delete "/api/spots/999999"
    end

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal ["Spot not found"], response_json["errors"]
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
