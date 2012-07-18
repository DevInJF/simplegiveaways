class AddActiveFlagToGiveaway < ActiveRecord::Migration
  def change
    add_column :giveaways, :active, :boolean, default: false
  end
end
