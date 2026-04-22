require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "is valid with a name" do
    tag = Tag.new(name: "ramen")

    assert tag.valid?
  end

  test "is invalid without a name" do
    tag = Tag.new(name: nil)

    assert_not tag.valid?
    assert_includes tag.errors[:name], "can't be blank"
  end

  test "is invalid with a duplicate name" do
    tag = Tag.new(name: tags(:one).name)

    assert_not tag.valid?
    assert_includes tag.errors[:name], "has already been taken"
  end

  test "has many spots through spot tags" do
    tag = tags(:one)

    assert_includes tag.spots, spots(:one)
  end
end
