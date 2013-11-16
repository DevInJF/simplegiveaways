class ModifySubscriptionsAssocs < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :user_id
    add_column :users, :subscription_id, :integer
  end

  def down
    add_column :subscriptions, :user_id, :integer
    remove_column :users, :subscription_id
  end
end
