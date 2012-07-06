class RenameViralLikesToLikes < ActiveRecord::Migration

  def up
    rename_table :viral_likes, :likes
  end

  def down
    rename_table :likes, :viral_likes
  end
end
