class NewsController < ApplicationController

NEWS_API_KEY = ENV["NEWS_API_KEY"]

  def get_articles
    response = RestClient.get("https://newsapi.org/v2/top-headlines?sources=abc-news,%20associated-press,%20reuters,%20axios,the-washington-post,%20cnn,%20the-wall-street-journal,%20bloomberg,%20fox-news&apiKey=#{NEWS_API_KEY}")
    response_hash = JSON.parse(response)
    render json: response_hash
  end
end
