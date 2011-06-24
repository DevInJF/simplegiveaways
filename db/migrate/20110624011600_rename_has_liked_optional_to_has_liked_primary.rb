class RenameHasLikedOptionalToHasLikedPrimary < ActiveRecord::Migration
  def self.up
    rename_column :entries, :has_liked_optional, :has_liked_primary
  end

  def self.down
    rename_column :entries, :has_liked_primary, :has_liked_optional
  end
end
