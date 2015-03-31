class User < ActiveRecord::Base
  # Forces username/email to be lower-case before addition to the database
  def downcase_details
    self.username	= self.username.downcase	if self.username.present?
    self.email		= self.email.downcase		if self.email.present?
  end
  
  before_validation :downcase_details
  
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }
  EMAIL_VALIDATOR = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # A simple email address validing Regex from Ruby on Rails Tutorial (3rd Ed.) by Michael Hartl
  validates :email, presence: true, length: { maximum: 255 }, format: { with: EMAIL_VALIDATOR }
  
  private :downcase_details
end
