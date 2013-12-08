class AddNextColumnsToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :activate_next_after, :datetime
    add_column :subscriptions, :next_plan_id, :integer
  end
end
