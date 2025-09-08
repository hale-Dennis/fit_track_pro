require 'faker'

FactoryBot.define do
  factory :workout_plan do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    difficulty { WorkoutPlan::DIFFICULTY_LEVELS.sample }

    association :user
  end
end