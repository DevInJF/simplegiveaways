class AddUniquenessToCreditCardsUsers < ActiveRecord::Migration
  def self.up
    add_index :credit_cards_users, [:credit_card_id, :user_id], :unique => true, :name => 'by_credit_card_and_user'
  end

  def self.down
    remove_index :credit_cards_users, [:credit_card_id, :user_id]
  end
end
