require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  describe '#new' do
    it "redirects to 'auth/linkedin'" do
      get :new, role: Role::MEMBER
      expect(controller).to redirect_to("/auth/linkedin")
    end

    it "stores the role in the session" do
      get :new, role: Role::RECRUITER
      expect(session[:role]).to eq(Role::RECRUITER)
    end
  end

  describe "#create" do
    let(:updater) { double('updater', perform: true, authentication: authentication) }
    let(:authentication) { double('authentication', id: 1234, primary_role: role) }
    let(:role) { Role::MEMBER }

    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:linkedin]
      allow(AuthenticationUpdater).to receive(:new).and_return(updater)
    end

    context 'when the session shows they are a member' do
      before do
        session[:role] = role
      end

      it "passes the oauth data to the AuthenticationUpdater" do
        expect(AuthenticationUpdater).to receive(:new).with(linkedin_oauth_data, role).and_return(updater)
        expect(updater).to receive(:perform)
        post :create
      end

      it "logs the authentication in" do
        expect(controller).to receive(:sign_in).with(authentication)
        post :create
      end

      it "redirects to the member jobs page" do
        post :create
        expect(controller).to redirect_to("/members/1234/jobs")
      end
    end

    context 'when the session shows they are an recruiter' do
      let(:role) { Role::RECRUITER }

      before do
        session[:role] = role
      end

      it "passes the auth data to the RecruiterUpdater" do
        expect(AuthenticationUpdater).to receive(:new).with(linkedin_oauth_data, role).and_return(updater)
        expect(updater).to receive(:perform)
        post :create
      end

      it "logs the authentication in" do
        expect(controller).to receive(:sign_in).with(authentication)
        post :create
      end

      it "redirects to their jobs page" do
        post :create
        expect(controller).to redirect_to("/recruiters/1234/jobs")
      end
    end

    context 'when the session has not information' do
      let(:role) { nil }

      before do
        session[:role] = role
        allow(authentication).to receive(:primary_role).and_return(Role::MEMBER)
      end

      it "passes the oauth data to the AuthenticationUpdater" do
        expect(AuthenticationUpdater).to receive(:new).with(linkedin_oauth_data, role).and_return(updater)
        expect(updater).to receive(:perform)
        post :create
      end

      it "logs the authentication in" do
        expect(controller).to receive(:sign_in).with(authentication)
        post :create
      end

      it "redirects to the member jobs page" do
        post :create
        expect(controller).to redirect_to("/members/1234/jobs")
      end
    end

    context 'when the omniauth credentials are invalid' do
      before do
        session[:role] = 'member'
      end
    end
  end
end
