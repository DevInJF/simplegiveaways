class AddUniqueIndexesToLikes < ActiveRecord::Migration
  def change
    add_index :likes, [:fb_uid, :giveaway_id], unique: true
    add_index :likes, [:entry_id, :giveaway_id], unique: true
  end
end
