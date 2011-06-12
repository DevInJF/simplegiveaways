class AddUniqueIndexToGiveaways < ActiveRecord::Migration
  def self.up
    add_index :giveaways, [:title, :facebook_page_id], :unique => true
  end

  def self.down
    remove_index :giveaways, :title
  end
end
