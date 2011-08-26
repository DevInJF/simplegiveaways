class AddPurchasedAtToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :purchased_at, :time
  end

  def self.down
    remove_column :transactions, :purchased_at
  end
end
