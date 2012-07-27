class AddFromEntryToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :from_entry, :boolean, :default => false
  end
end
