class Api::V1::PostsController < ApplicationController
  before_action :find_post, only: [:show, :update, :destroy]
  skip_before_action :authorized, only: [:index]

  def index
    posts = Post.all
    render json: posts
  end
  
  def create
    user = User.find(post_params[:user_id])
    post = user.posts.build(post_params)

    if post.valid?
      post.save
      render json: post, status: :created
    else 
      render json: {error: post.errors.full_messages}, status: :not_acceptable
    end
  end

  def show
    render json: @post, status: :ok
  end

  def update
    @post.update(post_params)

    if @post.valid?
      @post.save
      render json: @post, status: :ok
    else 
      render json: {error: post.errors.full_messages}, status: :not_acceptable
    end
  end

  def destroy
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:text, :image, :user_id)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
