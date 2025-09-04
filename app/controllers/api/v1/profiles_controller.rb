class Api::V1::ProfilesController < Api::V1::ApplicationController
  def show
    render_profile
  end

  def update
    if @current_user.update(profile_params)
      render_profile
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :profile_picture)
  end

  def render_profile
    profile_data = {
      id: @current_user.id,
      name: @current_user.name,
      email: @current_user.email,
      role: @current_user.role
    }
    if @current_user.profile_picture.attached?
      profile_data[:profile_picture_url] = url_for(@current_user.profile_picture)
    end

    render json: profile_data, status: :ok
  end
end