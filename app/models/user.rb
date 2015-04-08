class User < ActiveRecord::Base
  has_many :subscriptions

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # Forces username/email to be lower-case before addition to the database
  def downcase_details
    self.username	= self.username.downcase	if self.username.present?
    self.email		= self.email.downcase		if self.email.present?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
  end
  
  before_validation :downcase_details
  
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }
  EMAIL_VALIDATOR = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # A simple email address validing Regex from Ruby on Rails Tutorial (3rd Ed.) by Michael Hartl
  validates :email, presence: true, length: { maximum: 255 }, format: { with: EMAIL_VALIDATOR }
  
  private :downcase_details
end
