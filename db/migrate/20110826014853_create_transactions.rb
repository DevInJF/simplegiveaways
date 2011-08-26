class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string   "first_name"
      t.string   "last_name"
      t.string   "ip_address"
      t.string   "product"
      t.integer  "amount"
      t.integer  "user_id"
      t.boolean  "success"
      t.string   "authorization"
      t.string   "message"
      t.text     "params"
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
