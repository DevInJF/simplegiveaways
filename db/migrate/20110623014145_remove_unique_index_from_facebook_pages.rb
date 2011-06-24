class RemoveUniqueIndexFromFacebookPages < ActiveRecord::Migration
  def self.up
    remove_index :facebook_pages, :pid
  end

  def self.down
    add_index :facebook_pages, :pid, :unique => true
  end
end
