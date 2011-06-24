class RenameOptionalLikesToMandatoryLikes < ActiveRecord::Migration
  def self.up
    rename_column :giveaways, :optional_likes, :mandatory_likes
  end

  def self.down
    rename_column :giveaways, :mandatory_likes, :optional_likes
  end
end
