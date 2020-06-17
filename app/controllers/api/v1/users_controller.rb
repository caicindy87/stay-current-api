class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  
  def create
    user = User.new(user_params)

    if user.valid?
      user.save
      token = issue_token(user)

      render json: {id: user.id, username: user.username, profile_pic: user.profile_pic, bio: user.bio, token: token}, status: :created
    else 
      render json: {error: user.errors.full_messages}, status: :not_acceptable
    end
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)

    if user.valid?
      user.save

      render json: {id: user.id, username: user.username, profile_pic: user.profile_pic, bio: user.bio, token: token}, status: :accepted
    else
      render json: {error: user.errors.full_messages}, status: :not_acceptable
    end
  end

  private 
  
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email, :profile_pic, :bio)
  end
end
