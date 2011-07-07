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

  validate :end_in_future
 
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
    now = Time.now
    if start_date < now && end_date > now
      return true
    else
      false
    end
  end
  
  def is_installed?
    fql = Facebook::Fql.new("224405887571151|d8c509f8698861e58a35203f.0-808283|B8A_LuTwhW5LNnXsz6_hI5cRjVI")
    pid = facebook_page.pid
    response = fql.query("SELECT has_added_app FROM page WHERE page_id=#{pid}")
    response[0]["has_added_app"]
  end

  private

  def end_in_future
    if end_date < start_date
      errors[:base] << "End date must be in the future"
    end
  end
end