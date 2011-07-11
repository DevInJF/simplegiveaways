class ChangeEntryUidToBigint < ActiveRecord::Migration
  def self.up
    change_table :entries do |t|
      t.change :uid, :string
    end
  end

  def self.down
    change_table :entries do |t|
      t.change :uid, :integer
    end
  end
end
