class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :text, :image, :upvotes, :downvotes, :created_at
  belongs_to :user
  has_many :tags, through: :post_tags

  def image
    if object.image.attached?
      {url: url_for(object.image), signed_id: object.image.signed_id}
    end
  end
end
