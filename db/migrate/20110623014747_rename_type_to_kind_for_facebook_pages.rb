class RenameTypeToKindForFacebookPages < ActiveRecord::Migration
  def self.up
    rename_column :facebook_pages, :type, :kind
  end

  def self.down
    rename_column :facebook_pages, :kind, :type
  end
end
