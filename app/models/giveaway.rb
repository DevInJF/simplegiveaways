class Giveaway < ActiveRecord::Base
  is_impressionable

  has_and_belongs_to_many :users
  belongs_to :facebook_page
  has_many :entries
  has_many :accessory_fb_pages

  validates :title, :presence => true, :uniqueness => { :scope => :facebook_page_id }
  validates :facebook_page_id, :presence => true
  validates :description, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :prize, :presence => true
  validates_attachment_presence :image
  validates_attachment_presence :feed_image
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
    start_date < now && end_date > now ? true : false
  end
  
  def is_installed?
    @rest = Koala::Facebook::RestAPI.new(FB_APP_KEY)
    @rest.fql_query("SELECT has_added_app FROM page WHERE page_id=#{facebook_page.pid}")[0]["has_added_app"]
  end

  private

  def end_in_future
    if end_date < start_date
      errors[:base] << "End date must be in the future"
    end
  end
end