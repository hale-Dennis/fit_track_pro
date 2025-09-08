class WorkoutPlanPolicy < ApplicationPolicy
  def create?
    user.coach?
  end
end