require "test_helper"

class Api::CategoriesControllerTest < ActionDispatch::IntegrationTest
  CATEGORY_RESPONSE_KEYS = %w[
    id
    name
    created_at
    updated_at
  ].freeze

  test "lists categories" do
    get "/api/categories"

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal 2, response_json.length
    assert_equal [ categories(:one).id, categories(:two).id ].sort, response_json.map { |category| category["id"] }.sort
    assert_equal CATEGORY_RESPONSE_KEYS.sort, response_json.first.keys.sort
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
    assert_equal CATEGORY_RESPONSE_KEYS.sort, response_json.keys.sort
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

  test "updates a category" do
    patch "/api/categories/#{categories(:one).id}",
      params: { category: { name: "Coffee Shop" } },
      as: :json

    assert_response :ok

    response_json = JSON.parse(response.body)

    assert_equal "Coffee Shop", response_json["name"]
    assert_equal CATEGORY_RESPONSE_KEYS.sort, response_json.keys.sort
    assert_equal "Coffee Shop", categories(:one).reload.name
  end

  test "returns not found when updating a non-existent category" do
    patch "/api/categories/999999",
      params: { category: { name: "Coffee Shop" } },
      as: :json

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal [ "Category not found" ], response_json["errors"]
  end

  test "returns errors when updating a category with duplicate name" do
    patch "/api/categories/#{categories(:one).id}",
      params: { category: { name: categories(:two).name } },
      as: :json

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_includes response_json["errors"], "Name has already been taken"
  end

  test "destroys a category without associated spots" do
    category = Category.create!(name: "Hot Spring")

    assert_difference("Category.count", -1) do
      delete "/api/categories/#{category.id}"
    end

    assert_response :no_content
  end

  test "returns not found when deleting a non-existent category" do
    assert_no_difference("Category.count") do
      delete "/api/categories/999999"
    end

    assert_response :not_found

    response_json = JSON.parse(response.body)

    assert_equal [ "Category not found" ], response_json["errors"]
  end

  test "returns errors when deleting a category with associated spots" do
    assert_no_difference("Category.count") do
      delete "/api/categories/#{categories(:one).id}"
    end

    assert_response :unprocessable_entity

    response_json = JSON.parse(response.body)

    assert_equal [ "Cannot delete category with associated spots" ], response_json["errors"]
  end
end
