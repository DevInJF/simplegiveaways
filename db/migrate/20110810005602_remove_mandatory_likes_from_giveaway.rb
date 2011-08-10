class RemoveMandatoryLikesFromGiveaway < ActiveRecord::Migration
  def self.up
    remove_column :giveaways, :mandatory_likes
  end

  def self.down
    add_column :giveaways, :mandatory_likes, :text
  end
end
