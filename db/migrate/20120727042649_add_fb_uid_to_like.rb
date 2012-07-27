class AddFbUidToLike < ActiveRecord::Migration
  def change
    add_column :likes, :fb_uid, :string
  end
end
