class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :email
      t.boolean :has_liked_mandatory
      t.boolean :has_liked_optional
      t.string :name
      t.string :fb_url
      t.datetime :datetime_entered
      t.boolean :has_shared
      t.integer :share_count
      t.integer :invite_count
      t.integer :convert_count
      t.integer :giveaway_id
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
