class DropBillingAddresses < ActiveRecord::Migration
  def self.up
    drop_table :billing_addresses
  end

  def self.down
    create_table :billing_addresses do |t|
      t.string "name"
      t.string "address1"
      t.string "address2"
      t.string "city"
      t.string "state"
      t.string "country"
      t.string "zip"
      t.string "phone"
      t.integer "credit_card_id"
      t.timestamps
    end
  end
end
