class AddIsViralFlagToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :is_viral, :boolean, default: false
  end
end
