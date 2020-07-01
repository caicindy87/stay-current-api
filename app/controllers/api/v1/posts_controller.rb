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

    render json: Post.posts_with_converted_created_at_attribute(posts)
  end
  
  def create
    user = User.find(post_params[:user_id])
    post = user.posts.build(post_params)
    
    if post.valid?
      post.save
    
      # Create post's tags if user selected tags
      if params[:selectedTags]
        params[:selectedTags].split(",").map{|string_num| string_num.to_i}.map do |tag_id|
          PostTag.create!(post_id: post.id, tag_id: tag_id)
        end
      end

      render json: {post_info: PostSerializer.new(post), publish_date: Post.convert_created_at_attribute_to_words(post)}, status: :created
    else 
      render json: {error: post.errors.full_messages}, status: :not_acceptable
    end
  end

  def show
    render json: {post_info: PostSerializer.new(@post), publish_date: Post.convert_created_at_attribute_to_words(@post)}, status: :ok
  end

  def update
    @post.update(post_params)

    if @post.valid?
      @post.save
      # byebug
      if params[:selectedTags]
        # handle user adding new tag(s)
        params[:selectedTags].split(",").map{|string_num| string_num.to_i}.map do |tag_id| 
          PostTag.find_or_create_by(post_id: @post.id, tag_id: tag_id)
        end

        # handle user removing tag(s)
        Post.find_removed_tags(params[:selectedTags], @post).each {|tag_id| @post.post_tags.find_by(tag_id: tag_id).destroy}
      end

      render json: {post_info: PostSerializer.new(@post), publish_date: Post.convert_created_at_attribute_to_words(@post)}, status: :ok
    else 
      render json: {error: @post.errors.full_messages}, status: :not_acceptable
    end
  end

  def destroy
    @post.post_tags.each {|post_tag| post_tag.destroy}
    @post.destroy
  end

  private

  def post_params
    params.permit(:id, :text, :image, :upvotes, :downvotes)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
