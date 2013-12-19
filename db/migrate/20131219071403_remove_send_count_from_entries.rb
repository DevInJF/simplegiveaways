class RemoveSendCountFromEntries < ActiveRecord::Migration
  def up
    remove_column :entries, :send_count
  end

  def down
    add_column :entries, :send_count, :integer, default: 0
  end
end
