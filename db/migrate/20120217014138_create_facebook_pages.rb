# -*- encoding : utf-8 -*-
class CreateFacebookPages < ActiveRecord::Migration
  def change
    create_table :facebook_pages do |t|
      t.string   :name
      t.string   :category
      t.string   :pid
      t.string   :token
      t.string   :avatar_square
      t.string   :avatar_large
      t.text     :description
      t.integer  :likes
      t.string   :url
      t.boolean  :has_added_app
      t.timestamps
    end
    add_index :facebook_pages, :pid, :unique => true
  end
end
