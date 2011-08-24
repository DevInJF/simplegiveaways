class AddUniqueIndexToCreditCard < ActiveRecord::Migration
  def self.up
    add_index :credit_cards, [:number, :user_id], :unique => true
  end

  def self.down
    remove_index :credit_cards, :name => "index_credit_cards_on_number_and_user_id"
  end
end
