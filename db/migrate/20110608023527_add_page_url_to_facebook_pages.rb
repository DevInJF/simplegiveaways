class AddPageUrlToFacebookPages < ActiveRecord::Migration
  def self.up
    add_column :facebook_pages, :url, :string
  end

  def self.down
    remove_column :facebook_pages, :url
  end
end
