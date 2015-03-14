require 'rails_helper'

RSpec.describe AuthenticationUpdater do
  let(:updater) { AuthenticationUpdater.new(data, role) }
  let(:data) { OmniAuth::AuthHash.new(sample_linkedin_data) }
  let(:role) { Roles::RECRUITER }

  let(:authentication) { updater.authentication }

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
        expect(authentication.uid).to eq("yEQgerbil")
        expect(authentication.email).to eq("baccigalup@gmail.com")
        expect(authentication.title).to eq("Coder, Teacher, Fixer")
      end

      it "creates the user with the right role" do
        updater.perform
        expect(authentication.primary_role).to eq(updater.role)
      end
    end

    context "when there is a matching authentication" do
      context 'when it matches on uid' do
        before do
          auth = Authentication.create(uid: data.uid, email: 'email')
          auth.roles.create(type: Roles::MEMBER)
        end

        it "does not create a new authentication" do
          expect { updater.perform }.not_to change { Authentication.count }
        end

        it "updates the email (if not a match)" do
          updater.perform
          expect(authentication.email).to eq('baccigalup@gmail.com')
        end

        it "updates other information" do
          updater.perform
          expect(authentication.title).to eq("Coder, Teacher, Fixer")
        end

        it "adds new roles" do
          updater.perform
          expect(authentication.roles.map(&:type)).to include(Roles::MEMBER, Roles::RECRUITER)
        end
      end

      context 'when it matches on email' do
        before do
          auth = Authentication.create(email: data.info.email, uid: 'uid')
          auth.roles.create(type: Roles::RECRUITER)
        end

        it "does not create a new authentication" do
          expect { updater.perform }.not_to change { Authentication.count }
        end

        it "updates the uid (if not a match)" do
          updater.perform
          expect(authentication.uid).to eq("yEQgerbil")
        end

        it "updates other information" do
          updater.perform
          expect(authentication.title).to eq("Coder, Teacher, Fixer")
        end

        it "does not create duplicate roles" do
          expect(authentication.roles.count).to eq(1)
        end
      end
    end
  end
end
