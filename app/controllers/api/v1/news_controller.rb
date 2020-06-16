class Api::V1::NewsController < ApplicationController
  skip_before_action :authorized

  NEWS_API_KEY = ENV["NEWS_API_KEY"]
 

  def get_articles
    page = params["page"].to_i
    
    response = RestClient.get("https://newsapi.org/v2/top-headlines?sources=abc-news,%20associated-press,%20reuters,%20axios,the-washington-post,%20the-wall-street-journal,%20bloomberg&apiKey=#{NEWS_API_KEY}&page=#{page}")
    response_hash = JSON.parse(response)
    render json: response_hash
  end
end
