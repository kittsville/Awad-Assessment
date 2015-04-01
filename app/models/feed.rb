class Feed < ActiveRecord::Base
  def downcase_url
    self.url = self.url.downcase if self.url.present?
  end
  
  before_validation :downcase_url
  
  validates :title, presence: true, length: { maximum: 150 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :url, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }

  private :downcase_url
end
