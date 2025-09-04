class Api::V1::SessionsController < Api::V1::ApplicationController

  skip_before_action :authenticate_request, only: [:create]

  def create
    @user = User.find_by(email: params[:email].downcase)

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end