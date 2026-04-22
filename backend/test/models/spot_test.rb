require "test_helper"

class SpotTest < ActiveSupport::TestCase
  test "is valid with required attributes" do
    spot = Spot.new(name: "Local Cafe", user: users(:one), category: categories(:one), status: :want_to_go)

    assert spot.valid?
  end

  test "is invalid without a name" do
    spot = Spot.new(name: nil, user: users(:one), category: categories(:one), status: :want_to_go)

    assert_not spot.valid?
    assert_includes spot.errors[:name], "can't be blank"
  end

  test "is invalid without a category" do
    spot = Spot.new(name: "Local Cafe", user: users(:one), category: nil, status: :want_to_go)

    assert_not spot.valid?
    assert_includes spot.errors[:category], "must exist"
  end

  test "is invalid without a user" do
    spot = Spot.new(name: "Local Cafe", user: nil, category: categories(:one), status: :want_to_go)

    assert_not spot.valid?
    assert_includes spot.errors[:user], "must exist"
  end

  test "is invalid with an unsupported status" do
    spot = Spot.new(name: "Local Cafe", user: users(:one), category: categories(:one), status: "archived")

    assert_not spot.valid?
    assert_includes spot.errors[:status], "is not included in the list"
  end

  test "allows duplicate names across spots" do
    spot = Spot.new(name: spots(:one).name, user: users(:one), category: categories(:two), status: :visited)

    assert spot.valid?
  end

  test "has many tags through spot tags" do
    spot = spots(:one)

    assert_includes spot.tags, tags(:one)
  end
end
