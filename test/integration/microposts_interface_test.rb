require "test_helper"

class MicropostsInterface < ActionDispatch::IntegrationTest
  def setup
    @user = users(:aske)
    log_in_as @user
  end
end

class MicropostsInterfaceTest < MicropostsInterface
  test "should paginate microposts" do
    get root_path
    assert_select "div.pagination"
  end

  test "should show errors but not create micropost on invalid submission" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {
        content: ""
      }}
    end
    assert_select "div#error_explanation"
    assert_select "a[href=?]", "/?page=2"
  end

  test "should create micropost on valid submission" do
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: {micropost: {content: "Micropost content"}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match "Micropost content", response.body
  end

  test "should have micropost delete links on own profile page" do
    get user_path(@user)
    assert_select "a", text: "delete"
  end

  test "should be able to delete own post" do
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
  end

  test "should not have delete links on other profiles" do
    get user_path(users(:sabina))
    assert_select "a", {text: "delete", count: 0}
  end
end

class MicropostsSideBarTest < MicropostsInterface
  test "should display right micropost count" do
    get root_path
    count = @user.microposts.count.to_s
    assert_match "#{count} microposts", response.body
  end

  test "should use proper pluralization for zero microposts" do
    log_in_as(users(:magne))
    get root_path
    assert_match "0 microposts", response.body
  end

  test "should use proper pluralization for one micropost" do
    log_in_as(users(:liva))
    get root_path
    assert_match "1 micropost", response.body
  end
end

class ImageUploadTest < MicropostsInterface
  test "should have file input field for images" do
    get root_path
    assert_select "input[type=file]"
  end

  test "should be able to attach an image" do
    post microposts_path, params: {micropost: {content: "Micropost content", image: fixture_file_upload("kitten.jpg", "image/jpg")}}
    assert assigns(:micropost).image.attached?
  end
end
