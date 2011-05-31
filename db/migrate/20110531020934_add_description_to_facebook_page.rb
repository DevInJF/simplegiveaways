class AddDescriptionToFacebookPage < ActiveRecord::Migration
  def self.up
    add_column :facebook_pages, :description, :text
  end

  def self.down
    remove_column :facebook_pages, :description
  end
end
