class ModifyEntry < ActiveRecord::Migration
  def self.up
    remove_column :entries, :has_shared
    add_column :entries, :status, :string
  end

  def self.down
    remove_column :entries, :status
    add_column :entries, :has_shared, :boolean
  end
end
