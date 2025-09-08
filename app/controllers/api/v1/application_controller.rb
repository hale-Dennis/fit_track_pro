class Api::V1::ApplicationController < ActionController::API
  include Authentication
  include Pundit::Authorization

  before_action :authenticate_request
  attr_reader :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_request
    token_data = decoded_token
    if token_data
      user_id = token_data[0]['user_id']
      @current_user = User.find(user_id)
    end

    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  end
end
