class Giveaway < ActiveRecord::Base
  belongs_to :user, :foreign_key => "user_id"
  belongs_to :facebook_page, :foreign_key => "facebook_page_id"

  validates_presence_of :title, :start_date, :end_date
  
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