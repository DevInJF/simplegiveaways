class AddHasSharedToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :has_shared, :boolean, default: false
  end
end
