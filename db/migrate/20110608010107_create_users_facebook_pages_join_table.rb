class CreateUsersFacebookPagesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :facebook_pages_users, :id => false do |t|
      t.column "facebook_page_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
    end
  end

  def self.down
    drop_table :facebook_pages_users
  end
end
