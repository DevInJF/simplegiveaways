class ModifyCreditCardsType < ActiveRecord::Migration
  def self.up
    rename_column :credit_cards, :type, :card_type
  end

  def self.down
    rename_column :credit_cards, :credit_card, :type
  end
end
