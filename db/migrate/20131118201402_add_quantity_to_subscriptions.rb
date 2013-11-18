class AddQuantityToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :quantity, :integer, default: 1
  end
end
