class RemoveUniqueIndexFromGiveaway < ActiveRecord::Migration
  def self.up
    remove_index :giveaways, :title_and_facebook_page_id
  end

  def self.down
    add_index :giveaways, [:title, :facebook_page_id], :unique => true
  end
end
