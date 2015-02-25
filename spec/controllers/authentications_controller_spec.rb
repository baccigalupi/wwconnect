require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  describe "#create" do
    let(:updater) { double('updater', perform: true, user: user) }
    let(:user) { double('user', id: 1234, primary_role: role) }
    let(:role) { Roles::MEMBER }

    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:linkedin]
      allow(MemberUpdater).to receive(:new).and_return(updater)
      allow(RecruiterUpdater).to receive(:new).and_return(updater)
    end

    context 'when the session shows they are a member' do
      before do
        session[:role] = role
      end

      it "passes the oauth data to the MemberUpdater" do
        expect(MemberUpdater).to receive(:new).with(linkedin_oauth_data).and_return(updater)
        expect(updater).to receive(:perform)
        post :create
      end

      it "logs the user in" do
        expect(controller).to receive(:sign_in).with(user)
        post :create
      end

      it "redirects to the member jobs page" do
        post :create
        expect(controller).to redirect_to("/member/jobs")
      end
    end

    context 'when the session shows they are an recruiter' do
      let(:role) { Roles::RECRUITER }

      before do
        session[:role] = role
      end

      it "passes the auth data to the RecruiterUpdater" do
        expect(RecruiterUpdater).to receive(:new).with(linkedin_oauth_data).and_return(updater)
        expect(updater).to receive(:perform)
        post :create
      end

      it "logs the user in" do
        expect(controller).to receive(:sign_in).with(user)
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
        allow(user).to receive(:primary_role).and_return(Roles::MEMBER)
      end

      it "passes the oauth data to the MemberUpdater" do
        expect(MemberUpdater).to receive(:new).with(linkedin_oauth_data).and_return(updater)
        expect(updater).to receive(:perform)
        post :create
      end

      it "logs the user in" do
        expect(controller).to receive(:sign_in).with(user)
        post :create
      end

      it "redirects to the member jobs page" do
        post :create
        expect(controller).to redirect_to("/member/jobs")
      end
    end

    context 'when the omniauth credentials are invalid' do
      before do
        session[:role] = 'member'
      end
    end
  end
end
