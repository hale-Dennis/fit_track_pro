require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            name: "John Doe",
            email: "john.doe@example.com",
            password: "password123",
            password_confirmation: "password123",
            role: "coach"
          }
        }
      end

      it "creates a new User" do
        expect {
          post "/api/v1/users", params: valid_params
        }.to change(User, :count).by(1)
      end

      it "returns a successful response with user data" do
        post "/api/v1/users", params: valid_params

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq("John Doe")
        expect(json_response['email']).to eq("john.doe@example.com")
        expect(json_response['role']).to eq("coach")
        expect(json_response).not_to have_key("password_digest")
      end
    end

    context "with invalid parameters" do
      it "does not create a new User with a duplicate email" do
        create(:user, email: "jane.doe@example.com")
        invalid_params = {
          user: {
            name: "Jane Doe",
            email: "jane.doe@example.com",
            password: "password123"
          }
        }

        post "/api/v1/users", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Email has already been taken")
      end
    end
  end
end