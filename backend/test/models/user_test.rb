require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with a name" do
    user = User.new(name: "New User")

    assert user.valid?
  end

  test "is invalid without a name" do
    user = User.new(name: nil)

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "has many spots" do
    user = users(:one)

    assert_includes user.spots, spots(:one)
  end
end
