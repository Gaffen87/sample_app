module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def logout
    reset_session
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end
end
