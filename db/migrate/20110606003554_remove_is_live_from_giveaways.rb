class RemoveIsLiveFromGiveaways < ActiveRecord::Migration
  def self.up
    remove_column :giveaways, :is_live
  end

  def self.down
    add_column :giveaways, :is_live, :boolean
  end
end
