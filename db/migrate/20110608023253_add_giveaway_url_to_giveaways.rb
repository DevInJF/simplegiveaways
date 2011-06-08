class AddGiveawayUrlToGiveaways < ActiveRecord::Migration
  def self.up
    add_column :giveaways, :giveaway_url, :string
  end

  def self.down
    remove_column :giveaways, :giveaway_url
  end
end
