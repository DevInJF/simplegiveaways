class CreateJoinTableForCreditCardsAndUsers < ActiveRecord::Migration
  def self.up
    create_table :credit_cards_users, :id => false do |t|
      t.column "credit_card_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
    end
  end

  def self.down
    drop_table :credit_cards_users
  end
end
