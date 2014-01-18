class AddBonusEntriesToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :bonus_entries, :integer, default: 0
  end
end
