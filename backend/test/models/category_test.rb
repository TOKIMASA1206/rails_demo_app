require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "is valid with a name" do
    category = Category.new(name: "Ramen")

    assert category.valid?
  end

  test "is invalid without a name" do
    category = Category.new(name: nil)

    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "is invalid with a duplicate name" do
    category = Category.new(name: categories(:one).name)

    assert_not category.valid?
    assert_includes category.errors[:name], "has already been taken"
  end
end
