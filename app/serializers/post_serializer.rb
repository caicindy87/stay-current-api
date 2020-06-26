class PostSerializer < ActiveModel::Serializer
  # include Rails.application.routes.url_helpers
  attributes :id, :text, :image, :upvotes, :downvotes, :created_at
  belongs_to :user
  has_many :tags, through: :post_tags

  def image
    if object.image.attached?
      {url: Rails.application.routes.url_helpers.rails_blob_url(object.image)}
    end
  end
end
