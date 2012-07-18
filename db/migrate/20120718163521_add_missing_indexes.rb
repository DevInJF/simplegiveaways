class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :audits, [:auditable_id, :auditable_type]
    add_index :facebook_pages_users, [:facebook_page_id]
    add_index :facebook_pages_users, [:user_id]
    add_index :likes, [:entry_id]
    add_index :likes, [:giveaway_id]
  end
end
