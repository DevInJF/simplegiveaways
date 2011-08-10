class ModifyCreditCards < ActiveRecord::Migration
  def self.up
    change_table :credit_cards do |t|
      t.change  :month, :string
      t.change  :year, :string
      t.change  :verification_value, :string
    end
  end

  def self.down
    change_table :credit_cards do |t|
      t.change  :month, :integer
      t.change  :year, :integer
      t.change  :verification_value, :integer
    end
  end
end
