class AddRefIdsToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :ref_ids, :text
  end
end
