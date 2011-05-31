class AddLikesCountToFacebookPage < ActiveRecord::Migration
  def self.up
    add_column :facebook_pages, :likes, :integer
  end

  def self.down
    remove_column :facebook_pages, :likes
  end
end
