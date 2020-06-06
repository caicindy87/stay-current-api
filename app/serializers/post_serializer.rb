class PostSerializer < ActiveModel::Serializer
  attributes :id, :text, :image, :upvotes, :downvotes, :created_at
  belongs_to :user
  has_many :tags, through: :post_tags
end
