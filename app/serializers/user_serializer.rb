class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :username, :email, :profile_pic

  def profile_pic
    if object.profile_pic.attached?
      {url: url_for(object.profile_pic), signed_id: object.profile_pic.signed_id}
    end
  end
end
