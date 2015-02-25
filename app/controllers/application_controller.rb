class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    reset_session
    @current_user = nil
    session[:user_id] = user.id if user
  end

  def current_user
    return @current_user if defined?(@current_user) && @current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end
end
