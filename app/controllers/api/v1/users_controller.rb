class Api::V1::UsersController < ActionController::API
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { id: @user.id, name: @user.name, email: @user.email, role: @user.role }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_content
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
