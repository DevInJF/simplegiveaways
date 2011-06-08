class RemoveForeignKeysFromUserAndFacebookPage < ActiveRecord::Migration
  def self.up
    remove_column :facebook_pages, :user_id
  end

  def self.down
    add_column :facebook_pages, :user_id, :integer
  end
end
