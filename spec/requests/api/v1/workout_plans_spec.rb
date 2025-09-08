require 'rails_helper'

RSpec.describe "Api::V1::WorkoutPlans", type: :request do
  include Authentication

  describe "POST /api/v1/workout_plans" do
    let(:valid_attributes) { { workout_plan: { title: 'Full Body Strength', description: 'A plan for all major muscle groups.', difficulty: 'Intermediate' } } }

    context "when the user is not authenticated" do
      it "returns a 401 Unauthorized status" do
        post "/api/v1/workout_plans", params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when the user is a member (and not authorized)" do
      let(:member) { create(:user, role: 'member') }
      let(:token) { jwt_encode(user_id: member.id) }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it "returns a 403 Forbidden status" do
        post "/api/v1/workout_plans", headers: headers, params: valid_attributes
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when the user is a coach (and authorized)" do
      let(:coach) { create(:user, :coach) } # Using our new trait
      let(:token) { jwt_encode(user_id: coach.id) }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      context "with valid parameters" do
        it "creates a new WorkoutPlan and returns a 201 Created status" do
          expect {
            post "/api/v1/workout_plans", headers: headers, params: valid_attributes
          }.to change(WorkoutPlan, :count).by(1)

          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response['title']).to eq('Full Body Strength')
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) { { workout_plan: { title: '' } } }

        it "returns a 422 Unprocessable Entity status" do
          post "/api/v1/workout_plans", headers: headers, params: invalid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end