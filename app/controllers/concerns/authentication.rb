require "jwt"

module Authentication
  extend ActiveSupport::Concern

  SECRET_KEY = ENV.fetch('JWT_SECRET_KEY', Rails.application.credentials.jwt_secret)

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(' ')[1]
      begin
        JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end
end