require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:aske)
  end

  test "profile display" do
    get user_path(@user)
    assert_template "users/show"
    assert_select "a[href=?]", following_user_path(@user), text: @user.following.count.to_s + " following"
    assert_select "a[href=?]", followers_user_path(@user), text: @user.followers.count.to_s + " followers"
    assert_select "title", full_title(@user.name)
    assert_select "h1", text: @user.name
    assert_select "h1>img.gravatar"
    assert_match @user.microposts.count.to_s, response.body
    assert_select "div.pagination", count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
