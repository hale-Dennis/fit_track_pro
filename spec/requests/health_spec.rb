require 'rails_helper'

RSpec.describe "Health", type: :request do
  describe "GET /index" do
    it "returns a successful response" do
      get "/health"

      expect(response).to have_http_status(:ok)
    end

    it "returns the correct JSON body" do
      get "/health"

      json_response = JSON.parse(response.body)
      expect(json_response).to eq({ "status" => "ok" })
    end
  end
end
