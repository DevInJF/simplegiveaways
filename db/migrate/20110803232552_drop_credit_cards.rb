class DropCreditCards < ActiveRecord::Migration
  def self.up
    drop_table :credit_cards
    drop_table :credit_cards_users
  end

  def self.down
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

    create_table :credit_cards_users, :id => false do |t|
      t.column "credit_card_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
    end
  end
end
