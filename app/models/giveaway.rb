class Giveaway < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :facebook_page
  has_many :entries
  
  serialize :optional_likes

  validates :title, :uniqueness => {:scope => :facebook_page_id}
  validates :facebook_page_id, :title, :start_date, :end_date, :presence => true
 
  # Paperclip 
  has_attached_file :image,
    :styles => {
      :thumb=> "100x100>",
      :small  => "150x150>",
      :medium => "300x300>",
      :large =>   "400x400>" },
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
end