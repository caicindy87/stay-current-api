class Api::V1::PostTagsController < ApplicationController
  skip_before_action :authorized, only: [:index]

  def index
    post_tags = PostTag.all
    render json: post_tags, status: :ok
  end

  def create
    post_tag = PostTag.create(post_id: params[:post_id], tag_id: params[:tag_id])

    render json: post_tag, status: :ok
  end
end
