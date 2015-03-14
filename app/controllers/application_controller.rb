class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(authentication)
    reset_session
    @current_user = nil
    session[:authentication_id] = authentication.id if authentication
  end

  # kind of misnamed, but an easier to understand abstraction ??
  def current_user
    return @current_user if defined?(@current_user) && @current_user
    @current_user = Authentication.find(session[:authentication_id]) if session[:authentication_id]
  end
end
