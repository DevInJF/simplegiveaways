class RemoveKindFromFacebookPage < ActiveRecord::Migration
  def self.up
    remove_column :facebook_pages, :kind
  end

  def self.down
    add_column :facebook_pages, :kind, :string
  end
end
