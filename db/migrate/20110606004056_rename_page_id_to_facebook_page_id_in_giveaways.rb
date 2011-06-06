class RenamePageIdToFacebookPageIdInGiveaways < ActiveRecord::Migration
  def self.up
    rename_column :giveaways, :page_id, :facebook_page_id
  end

  def self.down
    rename_column :giveaways, :facebook_page_id, :page_id
  end
end
