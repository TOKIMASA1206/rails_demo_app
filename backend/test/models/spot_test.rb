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

  test "in_category returns spots for the category" do
    assert_equal [ spots(:one) ], Spot.in_category(categories(:one).id)
  end

  test "sorted_by applies the requested sort order" do
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

    assert_equal [ spot_a, spots(:one), spots(:two), spot_c ], Spot.sorted_by("name_asc")
  end

  test "valid_sort returns true for supported sort values" do
    assert Spot.valid_sort?("name_asc")
  end

  test "valid_sort returns false for unsupported sort values" do
    assert_not Spot.valid_sort?("name_desc")
  end
end
