require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:aske)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: {user: {
      name: "",
      email: "invalid@email",
      password: "wrong",
      password_confirmation: "notthesame"
    }}
    assert_template "users/edit"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors", 8
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    assert_redirected_to edit_user_url(@user)
    name = "Test Navn"
    email = "test@example.com"
    patch user_path(@user), params: {user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
