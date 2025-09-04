require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /api/v1/login" do
    let!(:user) { create(:user, password: 'password123') }

    context "with valid credentials" do
      before do
        post "/api/v1/login", params: { email: user.email, password: 'password123' }
      end

      it "returns a 200 OK status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a JWT token" do
        json_response = JSON.parse(response.body)
        expect(json_response['token']).not_to be_empty
      end
    end

    context "with invalid credentials" do
      before do
        post "/api/v1/login", params: { email: user.email, password: 'wrongpassword' }
      end

      it "returns a 401 Unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end