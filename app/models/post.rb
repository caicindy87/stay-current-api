class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_one_attached :image

  validates :text, presence: true, length: { minimum: 1, maximum: 500 }
  validates :upvotes, :downvotes, numericality: { greater_than_or_equal_to: 0 }

  # converts all posts' created_at attribute to words for posts#index
  def self.posts_with_converted_created_at_attribute(posts)
    posts.map do |post| 
      publish_date = ActionController::Base.helpers.distance_of_time_in_words(post.created_at, DateTime.now)
      
      {post_info: PostSerializer.new(post), publish_date: publish_date}
    end
  end

  # convert one post's created_at attribute to words
  def self.convert_created_at_attribute_to_words(post)
    ActionController::Base.helpers.distance_of_time_in_words(post.created_at, DateTime.now)
  end

  # find tags that have been removed in updated post
  def self.find_removed_tags(selected_tags, post)
    updated_selected_tag_ids = selected_tags.split(",").map{|string_num| string_num.to_i}
    current_selected_tag_ids = post.post_tags.map {|post_tag| post_tag.tag.id}
    current_selected_tag_ids - updated_selected_tag_ids
  end

end
