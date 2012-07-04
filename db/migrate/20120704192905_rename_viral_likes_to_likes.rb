class RenameViralLikesToLikes < ActiveRecord::Migration
  def change
    rename_table :likes, :likes
  end
end
