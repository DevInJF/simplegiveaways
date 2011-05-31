class AddAvatarToFacebookPages < ActiveRecord::Migration
  def self.up
    add_column :facebook_pages, :avatar, :string
  end

  def self.down
    remove_column :facebook_pages, :avatar
  end
end
