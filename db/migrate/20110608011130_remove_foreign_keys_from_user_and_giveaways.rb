class RemoveForeignKeysFromUserAndGiveaways < ActiveRecord::Migration
  def self.up
    remove_column :giveaways, :user_id
  end

  def self.down
    add_column :giveaways, :user_id, :integer
  end
end
