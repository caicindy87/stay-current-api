class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.valid?
      user.save
      render json: {id: user.id, username: user.username}, status: :created
    else 
      render json: {error: user.errors.full_messages}, status: :not_acceptable
    end
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end
end
