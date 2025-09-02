require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'member' }

    trait :coach do
      role { 'coach' }
    end
  end
end