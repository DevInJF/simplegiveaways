class RemoveMustLikeFromGiveaway < ActiveRecord::Migration
  def self.up
    remove_column :giveaways, :must_like
  end

  def self.down
    add_column :giveaways, :must_like, :boolean
  end
end
