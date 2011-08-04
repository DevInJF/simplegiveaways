class RemoveGiveawaysUsersJoinTable < ActiveRecord::Migration
  def self.up
    drop_table :giveaways_users
  end

  def self.down
    create_table :giveaways_users, :id => false do |t|
      t.column "giveaway_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
    end
  end
end
