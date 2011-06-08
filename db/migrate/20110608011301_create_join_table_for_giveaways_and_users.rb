class CreateJoinTableForGiveawaysAndUsers < ActiveRecord::Migration
  def self.up
    create_table :giveaways_users, :id => false do |t|
      t.column "giveaway_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
    end
  end

  def self.down
    drop_table :giveaways_users
  end
end
