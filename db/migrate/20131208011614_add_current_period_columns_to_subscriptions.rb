class AddCurrentPeriodColumnsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :current_period_start, :datetime
    add_column :subscriptions, :current_period_end, :datetime
  end
end
