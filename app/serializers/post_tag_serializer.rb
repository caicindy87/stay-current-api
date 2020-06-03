class PostTagSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :tag
  belongs_to :post
end
