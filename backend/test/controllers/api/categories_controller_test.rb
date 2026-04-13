require "test_helper"

class Api::CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "lists categories" do
    get "/api/categories"

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal 2, response_json.length
    assert_equal [categories(:one).id, categories(:two).id].sort, response_json.map { |category| category["id"] }.sort
  end

  test "creates a category" do
    assert_difference("Category.count", 1) do
      post "/api/categories",
        params: { category: { name: "Ramen" } },
        as: :json
    end

    assert_response :created

    response_json = JSON.parse(response.body)

    assert_equal "Ramen", response_json["name"]
  end

  test "returns errors when category is invalid" do
    assert_no_difference("Category.count") do
      post "/api/categories",
        params: { category: { name: "" } },
        as: :json
    end

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_includes response_json["errors"], "Name can't be blank"
  end

  test "returns errors when category name is duplicated" do
    assert_no_difference("Category.count") do
      post "/api/categories",
        params: { category: { name: categories(:one).name } },
        as: :json
    end

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_includes response_json["errors"], "Name has already been taken"
  end
end
