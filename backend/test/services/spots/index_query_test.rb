require "test_helper"

module Spots
  class IndexQueryTest < ActiveSupport::TestCase
    test "returns all spots without filters" do
      spots = IndexQuery.new.call

      assert_equal [ spots(:one).id, spots(:two).id ].sort, spots.map(&:id).sort
    end

    test "filters spots by category" do
      spots = IndexQuery.new(category_id: categories(:one).id).call

      assert_equal [ spots(:one) ], spots
    end

    test "sorts spots by requested order" do
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

      spots = IndexQuery.new(sort: "name_asc").call

      assert_equal [ spot_a, spots(:one), spots(:two), spot_c ], spots
    end

    test "combines category filter and sort" do
      spot_a = Spot.create!(
        user: users(:one),
        category: categories(:one),
        name: "Apple Cafe",
        status: "want_to_go"
      )

      spots = IndexQuery.new(category_id: categories(:one).id, sort: "name_asc").call

      assert_equal [ spot_a, spots(:one) ], spots
    end
  end
end
