class RemoveQuantityFromSubscriptions < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :quantity
  end

  def down
    add_column :subscriptions, :quantity, :integer, default: 0
  end
end
