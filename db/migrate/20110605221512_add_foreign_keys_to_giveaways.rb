class AddForeignKeysToGiveaways < ActiveRecord::Migration
  def self.up
    add_column :giveaways, :user_id, :integer
    add_column :giveaways, :page_id, :integer
  end

  def self.down
    remove_column :giveaways, :user_id
    remove_column :giveaways, :page_id
  end
end
