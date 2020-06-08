class Api::V1::PostsController < ApplicationController
  before_action :find_post, only: [:show, :update, :destroy]
  skip_before_action :authorized, only: [:index]

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      posts = user.posts
    else
      posts = Post.all
    end

    posts_with_converted_created_at_attribute = posts.map do |post| 
      publish_date = ActionController::Base.helpers.distance_of_time_in_words(post.created_at, DateTime.now)
      
      {post_info: PostSerializer.new(post), publish_date: publish_date}
    end

    render json: posts_with_converted_created_at_attribute
  end
  
  def create
    user = User.find(post_params[:user_id])
    post = user.posts.build(post_params)
    
    if post.valid?
      post.save
      
      params[:selected_tags].map do |tag| 
        PostTag.create(post_id: post.id, tag_id: tag) 
      end      

      publish_date = ActionController::Base.helpers.distance_of_time_in_words(post.created_at, DateTime.now)

      render json: {post_info: PostSerializer.new(post), publish_date: publish_date}, status: :created
    else 
      render json: {error: post.errors.full_messages}, status: :not_acceptable
    end
  end

  def show
    publish_date = ActionController::Base.helpers.distance_of_time_in_words(@post.created_at, DateTime.now)

    render json: {post_info: PostSerializer.new(@post), publish_date: publish_date}, status: :ok
  end

  def update
    @post.update(post_params)

    if @post.valid?
      @post.save

      params[:selected_tags].map do |tag| 
        PostTag.find_or_create_by(post_id: @post.id, tag_id: tag) 
      end      
     
      publish_date = ActionController::Base.helpers.distance_of_time_in_words(@post.created_at, DateTime.now)

      render json: {post_info: PostSerializer.new(@post), publish_date: publish_date}, status: :ok
    else 
      render json: {error: post.errors.full_messages}, status: :not_acceptable
    end
  end

  def destroy
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:text, :image, :user_id, :upvotes, :downvotes)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
