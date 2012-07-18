class CreateViralLikes < ActiveRecord::Migration
  def change
    create_table :viral_likes do |t|
      t.integer :entry_id
      t.integer :giveaway_id, null: false
      t.timestamps
    end
  end
end
