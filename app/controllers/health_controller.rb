# frozen_string_literal: true

class HealthController < ActionController::API
  def index
    render json: { status: 'ok' }
  end
end