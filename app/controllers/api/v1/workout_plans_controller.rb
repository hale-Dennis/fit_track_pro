class Api::V1::WorkoutPlansController < Api::V1::ApplicationController
  def create
    @workout_plan = current_user.workout_plans.build(workout_plan_params)
    authorize @workout_plan

    if @workout_plan.save
      render json: @workout_plan, status: :created
    else
      render json: { errors: @workout_plan.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def workout_plan_params
    params.require(:workout_plan).permit(:title, :description, :difficulty)
  end
end