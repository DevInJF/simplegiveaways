class AddUniqueIndexToEntries < ActiveRecord::Migration
  def self.up
    add_index :entries, [:email, :giveaway_id], :unique => true
  end

  def self.down
    remove_index :entries, :email
  end
end
