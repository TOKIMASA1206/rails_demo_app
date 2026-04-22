require "test_helper"

class SpotTagTest < ActiveSupport::TestCase
  test "is valid with spot and tag" do
    spot_tag = SpotTag.new(spot: spots(:one), tag: tags(:two))

    assert spot_tag.valid?
  end

  test "is invalid without a spot" do
    spot_tag = SpotTag.new(spot: nil, tag: tags(:one))

    assert_not spot_tag.valid?
    assert_includes spot_tag.errors[:spot], "must exist"
  end

  test "is invalid without a tag" do
    spot_tag = SpotTag.new(spot: spots(:one), tag: nil)

    assert_not spot_tag.valid?
    assert_includes spot_tag.errors[:tag], "must exist"
  end

  test "is invalid with duplicate spot and tag pair" do
    spot_tag = SpotTag.new(spot: spots(:one), tag: tags(:one))

    assert_not spot_tag.valid?
    assert_includes spot_tag.errors[:spot_id], "has already been taken"
  end
end
