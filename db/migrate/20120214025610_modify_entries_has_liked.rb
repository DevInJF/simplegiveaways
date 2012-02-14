class ModifyEntriesHasLiked < ActiveRecord::Migration
  def self.up
    rename_column :entries, :has_liked_primary, :has_liked
    remove_column :entries, :has_liked_mandatory
  end

  def self.down
    add_column :entries, :has_liked_mandatory, :boolean
    rename_column :entries, :has_liked, :has_liked_primary
  end
end
