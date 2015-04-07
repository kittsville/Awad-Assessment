class Feed < ActiveRecord::Base
  has_many :subscriptions
  
  def downcase_url
    self.url = self.url.downcase if self.url.present?
    true
  end
  
  def default_values
    self.blacklisted = false if self.blacklisted.nil?
    true
  end 
  
  before_validation :downcase_url, :default_values
  
  validates :title, presence: true, length: { maximum: 150 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :url, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }

  private :downcase_url
end
