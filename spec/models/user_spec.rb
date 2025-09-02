require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }

    subject { build(:user) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'callbacks' do
    it 'downcases email before validation' do
      user = build(:user, email: 'TEST@EXAMPLE.COM')
      user.valid?
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'enums' do
    it 'defines the role enum with member and coach values' do
      expect(User.roles).to eq("member" => "member", "coach" => "coach")
    end
  end
end
