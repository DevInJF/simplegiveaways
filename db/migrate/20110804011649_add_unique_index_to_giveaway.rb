class AddUniqueIndexToGiveaway < ActiveRecord::Migration
  def self.up
    add_index :giveaways, [:title, :facebook_page_id], :unique => true
  end

  def self.down
    remove_index :giveaways, :name => "index_giveaways_on_title_and_facebook_page_id"
  end
end
