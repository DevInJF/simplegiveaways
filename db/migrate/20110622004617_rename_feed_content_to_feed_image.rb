class RenameFeedContentToFeedImage < ActiveRecord::Migration
  def self.up
    rename_column :giveaways, :feed_content, :feed_image
  end

  def self.down
    rename_column :giveaways, :feed_image, :feed_content
  end
end
