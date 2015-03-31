class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }
  EMAIL_VALIDATOR = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # A simple email address validing Regex from Ruby on Rails Tutorial (3rd Ed.) by Michael Hartl
  validates :email, presence: true, length: { maximum: 255 }, format: { with: EMAIL_VALIDATOR }
end
