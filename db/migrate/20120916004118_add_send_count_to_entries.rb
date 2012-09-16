class AddSendCountToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :send_count, :integer, default: 0
  end
end
