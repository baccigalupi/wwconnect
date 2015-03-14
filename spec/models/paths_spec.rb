require 'spec_helper'

RSpec.describe Paths do
  let(:paths) { Paths.new(authentication) }

  context 'when the authentication is nil' do
    let(:authentication) { nil }

    it "uses the NullPaths object" do
      expect(paths.home).to eq(Paths::NullPaths.new(authentication).home)
    end
  end

  context "when the authentication's default role is a recruiter" do
    let(:authentication) { double('authentication', id: 123, primary_role: Role::RECRUITER) }

    it "uses the RecruiterPaths object" do
      expect(paths.home).to eq(Paths::RecruiterPaths.new(authentication).home)
    end
  end

  context "when the authentication's default role is a member" do
    let(:authentication) { double('authentication', id: 123, primary_role: Role::MEMBER) }

    it "uses the MemberPaths object" do
      expect(paths.home).to eq(Paths::MemberPaths.new(authentication).home)
    end
  end
end
