class AddKindToFacebookPages < ActiveRecord::Migration
  def self.up
    add_column :facebook_pages, :kind, :string
  end

  def self.down
    remove_column :facebook_pages, :kind
  end
end
