class Api::V1::TagsController < ApplicationController
  def create
    Tag.create(name: params[:name])
  end
end
