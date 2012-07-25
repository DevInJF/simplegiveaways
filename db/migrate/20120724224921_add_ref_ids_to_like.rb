class AddRefIdsToLike < ActiveRecord::Migration
  def change
    add_column :likes, :ref_ids, :text
  end
end
