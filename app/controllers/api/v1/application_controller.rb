class Api::V1::ApplicationController < ActionController::API
  include Authentication

  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    token_data = decoded_token
    if token_data
      user_id = token_data[0]['user_id']
      @current_user = User.find(user_id)
    end

    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
  end
end
