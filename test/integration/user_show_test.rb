require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @inactive_user = users(:inactive)
    @activated_user = users(:aske)
  end

  test "should redirect when user not activated" do
    get user_path(@inactive_user)
    assert_response :found
    assert_redirected_to root_url
  end
  test "should display user when activated" do
    get user_path(@activated_user)
    assert_response :success
    assert_template "users/show"
  end
end
