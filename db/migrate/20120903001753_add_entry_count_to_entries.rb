class AddEntryCountToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entry_count, :integer, default: 1
  end
end
