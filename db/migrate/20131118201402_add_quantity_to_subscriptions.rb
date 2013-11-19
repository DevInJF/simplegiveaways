class AddQuantityToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :quantity, :integer, default: 0
  end
end
