class Giveaway < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :facebook_page
  has_many :entries
  has_many :accessory_fb_pages

  validates :title, :uniqueness => {:scope => :facebook_page_id}, :presence => true
  validates :facebook_page_id, :presence => true
  validates :description, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :prize, :presence => true
  validates :image, :presence => true
  validates :feed_image, :presence => true
  validates :terms, :presence => true
 
  # Paperclip 
  has_attached_file :image,
    :styles => {
      :thumb  => "150x150>",
      :medium => "300x300>" },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"
    
  has_attached_file :feed_image,
    :styles => {
      :thumb  => "45x45>",
      :feed => "90x90>" },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"

  def is_live?
    today = Date.today
    if self.start_date < today && self.end_date > today
      return true
    else
      return false
    end
  end
  
  def human_start_date
    self.start_date.strftime("%m/%d/%Y %H:%M")    
  end
  
  def human_end_date
    self.end_date.strftime("%m/%d/%Y %H:%M")
  end
  
  def fetch_mandatory_likes_meta
    
  end
end