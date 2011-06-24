class AddUniqueIndexToPidWithScope < ActiveRecord::Migration
  def self.up
    add_index :facebook_pages, :pid, :unique => true
  end

  def self.down
    remove_index :facebook_pages, :pid
  end
end
