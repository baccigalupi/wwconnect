require 'spec_helper'

RSpec.describe Paths do
  let(:paths) { Paths.new(user) }

  context 'when the user is nil' do
    let(:user) { nil }

    it "uses the NullPaths object" do
      expect(paths.home).to eq(Paths::NullPaths.new(user).home)
    end
  end

  context "when the user's default role is a recruiter" do
    let(:user) { double('user', id: 123, primary_role: Roles::RECRUITER) }

    it "uses the RecruiterPaths object" do
      expect(paths.home).to eq(Paths::RecruiterPaths.new(user).home)
    end
  end

  context "when the user's default role is a member" do
    let(:user) { double('user', id: 123, primary_role: Roles::MEMBER) }

    it "uses the MemberPaths object" do
      expect(paths.home).to eq(Paths::MemberPaths.new(user).home)
    end
  end
end
