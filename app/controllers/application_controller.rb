class ApplicationController < ActionController::API
  before_action :authorized

  def issue_token(user)
    JWT.encode({user_id: user.id}, auth_secret)
  end

  def token
    # { 'Authorization': 'Bearer <token>' }
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ")[1]
    end
  end

  def decoded_token
    if token
      begin
        JWT.decode(token, auth_secret)
      rescue JWT::DecodeError
        [{}]
      end
    end
  end

  def user_id
    if decoded_token
      decoded_token[0]["user_id"]
    end
  end

  def current_user
    user ||= User.find_by(id: user_id)
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { error: "Please log in" }, status: :unauthorized unless logged_in?
  end

  private

  def auth_secret
  ENV["AUTH_SECRET"]
  end
end
