class Api::V1::TagsController < ApplicationController
  def index
    tags = Tag.all
    render json: tags
  end

  def create
    Tag.create(name: params[:name])
  end
end
