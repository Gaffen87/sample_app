require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new name: "Test", email: "test@example.com", password: "password", password_confirmation: "password"
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should no be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "validation should accept valid emails" do
    valid_emails = %w[user@example.dk TEST@example.com a_us-er@example.test.org first.last@example.com aske+sabina@example.dk]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "validation should reject invalid emails" do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..dk]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "emails should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emails should be downcased" do
    @user.email = "ASKE@EXAMPLE.DK"
    @user.save
    assert_equal "aske@example.dk", @user.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end
end
