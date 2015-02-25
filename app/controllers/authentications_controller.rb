class AuthenticationsController < ApplicationController
  def create
    updater_class = session[:role] == 'recruiter' ? RecruiterUpdater : MemberUpdater
    updater = updater_class.new(request.env['omniauth.auth'])
    updater.perform
    sign_in(updater.user)
    redirect_to Paths.new(updater.user).home
  end
end
