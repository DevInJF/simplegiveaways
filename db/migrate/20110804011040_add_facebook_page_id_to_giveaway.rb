class AddFacebookPageIdToGiveaway < ActiveRecord::Migration
  def self.up
    add_column :giveaways, :facebook_page_id, :integer
  end

  def self.down
    remove_column :giveaways, :facebook_page_id
  end
end
