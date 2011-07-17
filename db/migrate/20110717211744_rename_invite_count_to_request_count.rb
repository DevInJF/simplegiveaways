class RenameInviteCountToRequestCount < ActiveRecord::Migration
  def self.up
    rename_column :entries, :invite_count, :request_count
  end

  def self.down
    rename_column :entries, :request_count, :invite_count
  end
end
