class AuthenticationsController < ApplicationController
  def new
    session[:role] = params[:role]
    redirect_to "/auth/linkedin"
  end

  def create
    updater = AuthenticationUpdater.new(request.env['omniauth.auth'], session[:role])
    updater.perform
    sign_in(updater.authentication)
    redirect_to Paths.new(updater.authentication).home
  end
end
