require 'rails_helper'

RSpec.describe AuthenticationUpdater do
  let(:updater) { AuthenticationUpdater.new(data, role) }
  let(:data) { OmniAuth::AuthHash.new(sample_linkedin_data) }
  let(:role) { Roles::RECRUITER }

  describe '#role' do
    it "should be the passed role if that is in the set" do
      expect(updater.role).to eq(role)
    end

    context 'when the role is not defined' do
      let(:role) { nil }

      it "should be 'member'" do
        expect(updater.role).to eq(Roles::MEMBER)
      end
    end

    context 'when the role is not valid' do
      let(:role) { 'admin' }

      it "should be 'member'" do
        expect(updater.role).to eq(Roles::MEMBER)
      end
    end
  end

  describe "#perform" do
    let(:authentication) { updater.authentication }

    context "when there is not a matching authentication" do
      it "creates a authentication and stores it on the updater" do
        expect { updater.perform }.to change {
          Authentication.count
        }.by(1)

        expect(authentication).to be_a(Authentication)
      end

      it "authentication has the right data" do
        updater.perform
        expect(authentication).to be_a(Authentication)
        expect(authentication.first_name).to eq('Kane')
        expect(authentication.last_name).to eq('Baccigalupi')
        expect(authentication.provider).to eq("linkedin")
        expect(authentication.uid).to eq("yEQgerbil")
        expect(authentication.email).to eq("baccigalup@gmail.com")
        expect(authentication.title).to eq("Coder, Teacher, Fixer")
        expect(authentication.image).to eq(data.info.image)
        expect(authentication.linkedin_url).to eq(data.info.urls.public_profile)
      end

      it "creates the user with the right role" do
        updater.perform
        expect(authentication.primary_role).to eq(updater.role)
      end
    end

    context "when there is a matching authentication" do
      it "does not create a new user"
      it "updates the authentication"
    end
  end
end
