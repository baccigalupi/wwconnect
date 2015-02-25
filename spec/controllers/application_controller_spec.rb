require 'rails_helper'

RSpec.describe ApplicationController do
  let(:user) { double('user', id: 123) }

  describe '#sign_in' do
    it "resets the current session" do
      expect(controller).to receive(:reset_session)
      controller.sign_in(user)
    end

    it "deletes the current user" do
      controller.instance_variable_set("@current_user", double('user'))
      controller.sign_in(user)
      expect { controller.current_user }.to raise_error # because this user isn't in the db
    end

    it "stores the user id in the session" do
      controller.sign_in(user)
      expect(session[:user_id]).to eq(123)
    end

    context 'when there is no user' do
      it "resets the session" do
        expect(controller).to receive(:reset_session)
        controller.sign_in(nil)
      end
    end
  end

  describe '#current_user' do
    context 'when the user_id is set in session' do
      before do
        session[:user_id] = user.id
      end

      it "finds it via the User model and the session id" do
        expect(User).to receive(:find).with(123).and_return(user)
        expect(controller.current_user).to eq(user)
      end
    end

    context 'when there is no user id' do 
      it "returns nil" do
        expect(controller.current_user).to eq(nil)
      end
    end
  end
end
