require 'rails_helper'

RSpec.describe "Api::V1::Profiles", type: :request do
  include Authentication
  include ActionDispatch::TestProcess::FixtureFile

  let!(:user) { create(:user) }
  let(:token) { jwt_encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:invalid_headers) { { 'Authorization' => "Bearer invalidtoken" } }

  describe "GET /api/v1/profile" do
    context "when the user is authenticated" do
      it "returns the user's profile" do
        get "/api/v1/profile", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(user.id)
        expect(json_response).not_to have_key('profile_picture_url')
      end

      it "returns the user's profile with a picture URL when attached" do
        user.profile_picture.attach(fixture_file_upload(Rails.root.join('spec/fixtures/test_image.png'), 'image/png'))

        get "/api/v1/profile", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['profile_picture_url']).to include('test_image.png')
      end
    end

    context "when the user is not authenticated" do
      it "returns an unauthorized error" do
        get "/api/v1/profile"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/v1/profile" do
    context "when the user is authenticated" do
      let(:new_name) { "New Test Name" }

      it "updates the user's name" do
        patch "/api/v1/profile", headers: headers, params: { profile: { name: new_name } }

        expect(response).to have_http_status(:ok)
        expect(user.reload.name).to eq(new_name)
      end

      it "does not allow updating the role" do
        patch "/api/v1/profile", headers: headers, params: { profile: { role: 'coach' } }

        expect(response).to have_http_status(:ok)
        expect(user.reload.role).to eq('member') # The role should NOT have changed
      end

      it "attaches the uploaded profile picture" do
        image = fixture_file_upload(Rails.root.join('spec/fixtures/test_image.png'), 'image/png')
        patch "/api/v1/profile", headers: headers, params: { profile: { profile_picture: image } }

        expect(response).to have_http_status(:ok)
        expect(user.reload.profile_picture).to be_attached
      end
    end

    context "when the user is not authenticated" do
      it "returns an unauthorized error" do
        patch "/api/v1/profile", params: { profile: { name: "New Name" } } # No headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end