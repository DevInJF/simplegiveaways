class AddShortlinkToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :shortlink, :string
  end
end
