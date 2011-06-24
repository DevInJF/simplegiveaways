class AddGiveawayIdToAccessoryFbPages < ActiveRecord::Migration
  def self.up
    add_column :accessory_fb_pages, :giveaway_id, :integer
  end

  def self.down
    remove_column :accessory_fb_pages, :giveaway_id
  end
end
