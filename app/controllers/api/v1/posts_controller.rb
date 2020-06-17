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
    
      params[:selected_tags_id].map do |tag_id| 
        PostTag.create(post_id: post.id, tag_id: tag_id) 
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
     
      if params[:selected_tags_id]
        # handle user adding new tag(s)
        params[:selected_tags_id].map do |tag_id| 
          PostTag.find_or_create_by(post_id: @post.id, tag_id: tag_id)
        end

        # handle user removing tag(s)
        Post.find_removed_tags(params[:selected_tags_id], @post).each {|tag_id| @post.post_tags.find_by(tag_id: tag_id).destroy}
      end

      render json: {post_info: PostSerializer.new(@post), publish_date: Post.convert_created_at_attribute_to_words(@post)}, status: :ok
    else 
      render json: {error: post.errors.full_messages}, status: :not_acceptable
    end
  end

  def destroy
    @post.post_tags.each {|post_tag| post_tag.destroy}
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
