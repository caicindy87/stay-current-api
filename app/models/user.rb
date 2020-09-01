class User < ApplicationRecord
  has_many :posts
  has_one_attached :profile_pic

  has_secure_password

  validates :username, presence: true, uniqueness: {case_sensitive: false}, length: { minimum: 5, maximum: 15 }

  validates :password, presence: true, length: { minimum: 5, maximum: 15 }, confirmation: true

  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
end
