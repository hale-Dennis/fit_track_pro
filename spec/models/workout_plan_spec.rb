require 'rails_helper'

RSpec.describe WorkoutPlan, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:difficulty) }

    it do
      should validate_inclusion_of(:difficulty)
               .in_array(WorkoutPlan::DIFFICULTY_LEVELS)
    end
  end
end