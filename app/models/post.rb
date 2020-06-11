class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :text, length: { minimum: 1, maximum: 500 }

  def self.posts_with_converted_created_at_attribute(posts)
    posts.map do |post| 
      publish_date = ActionController::Base.helpers.distance_of_time_in_words(post.created_at, DateTime.now)
      
      {post_info: PostSerializer.new(post), publish_date: publish_date}
    end
  end

  def self.convert_created_at_attribute_to_words(post)
    ActionController::Base.helpers.distance_of_time_in_words(post.created_at, DateTime.now)
  end
  
  def self.find_removed_tags(updated_selected_tag_ids, post)
    current_selected_tag_ids = post.post_tags.map {|post_tag| post_tag.tag.id}
    current_selected_tag_ids - updated_selected_tag_ids
  end

end
