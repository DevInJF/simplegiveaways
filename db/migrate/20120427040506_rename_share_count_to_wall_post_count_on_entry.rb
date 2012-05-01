class RenameShareCountToWallPostCountOnEntry < ActiveRecord::Migration
  def change
  	rename_column :entries, :share_count, :wall_post_count
  end
end
