require 'rails_helper'

RSpec.describe ApplicationController do
  let(:authentication) { double('authentication', id: 123) }

  describe '#sign_in' do
    it "resets the current session" do
      expect(controller).to receive(:reset_session)
      controller.sign_in(authentication)
    end

    it "deletes the current authentication" do
      controller.instance_variable_set("@current_user", double('authentication'))
      controller.sign_in(authentication)
      expect { controller.current_user }.to raise_error # because this authentication isn't in the db
    end

    it "stores the authentication id in the session" do
      controller.sign_in(authentication)
      expect(session[:authentication_id]).to eq(123)
    end

    context 'when there is no authentication' do
      it "resets the session" do
        expect(controller).to receive(:reset_session)
        controller.sign_in(nil)
      end
    end
  end

  describe '#current_user' do
    context 'when the authentication_id is set in session' do
      before do
        session[:authentication_id] = authentication.id
      end

      it "finds it via the authentication model and the session id" do
        expect(Authentication).to receive(:find).with(123).and_return(authentication)
        expect(controller.current_user).to eq(authentication)
      end
    end

    context 'when there is no authentication id' do
      it "returns nil" do
        expect(controller.current_user).to eq(nil)
      end
    end
  end
end
