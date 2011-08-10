class CreateCreditCardsAgain < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :credit_cards
  end
end
