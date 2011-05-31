class CreateFacebookPages < ActiveRecord::Migration
  def self.up
    create_table :facebook_pages do |t|
      t.integer :user_id
      t.string :name
      t.string :category
      t.string :pid
      t.string :token
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_pages
  end
end
