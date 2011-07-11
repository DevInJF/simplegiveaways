class AddUidToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :uid, :integer
  end

  def self.down
    remove_column :entries, :uid
  end
end
