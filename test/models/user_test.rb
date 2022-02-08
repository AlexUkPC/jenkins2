require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user can be created" do
    user = User.new
    assert user.invalid?
  end
end
