class PostSerializer < ActiveModel::Serializer
  attributes :id, :text, :image, :upvotes, :downvotes, :created_at
  belongs_to :user
  has_many :tags, through: :post_tags

  def image
    if object.image.attached?
      {url: Rails.application.routes.url_helpers.rails_blob_url(object.image), signed_id: object.image.signed_id}
    end
  end
end
