class CreditCard < ActiveRecord::Base
  has_and_belongs_to_many :users, :before_add => :validates_user
  
  def validates_user(user)
    raise ActiveRecord::Rollback if self.users.include? user
  end
end
