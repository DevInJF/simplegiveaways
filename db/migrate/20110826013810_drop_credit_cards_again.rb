class DropCreditCardsAgain < ActiveRecord::Migration
  def self.up
    drop_table :credit_cards
  end

  def self.down
    create_table :credit_cards do |t|
      t.string    "number"
      t.integer   "month"
      t.integer   "year"
      t.string    "first_name"
      t.string    "last_name"
      t.integer   "verification_value"
      t.string    "type"
      t.integer   "user_id"
      t.timestamps
    end
  end
end
