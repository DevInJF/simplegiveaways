class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.string :nickname
      t.string :name
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :type
      t.string :number
      t.date :expiration
      t.string :cvv
      t.timestamps
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
