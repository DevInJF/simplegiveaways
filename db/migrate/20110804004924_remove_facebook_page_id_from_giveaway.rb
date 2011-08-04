class RemoveFacebookPageIdFromGiveaway < ActiveRecord::Migration
  def self.up
    remove_column :giveaways, :facebook_page_id
  end

  def self.down
    add_column :giveaways, :facebook_page_id, :integer
  end
end
