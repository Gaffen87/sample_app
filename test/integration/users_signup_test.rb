require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "user not created on invalid input" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user:
                                   { name: "test",
                                     email: "invalid@address",
                                     password: "short",
                                     password_confirmation: "wrong"
                                   } }
    end
    assert_response :unprocessable_entity
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors", 6
  end

  test "user created on valid input" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: {
        name: "Test",
        email: "valid@address.com",
        password: "validpass",
        password_confirmation: "validpass"
      } }
    end
    follow_redirect!
    assert_template "users/show"
    assert logged_in?
    assert_not flash.empty?
  end
end
