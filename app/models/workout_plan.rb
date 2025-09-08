class WorkoutPlan < ApplicationRecord
  DIFFICULTY_LEVELS = %w[Beginner Intermediate Advanced].freeze

  belongs_to :user

  validates :title, presence: true
  validates :difficulty, presence: true,
            inclusion: { in: DIFFICULTY_LEVELS }
end
