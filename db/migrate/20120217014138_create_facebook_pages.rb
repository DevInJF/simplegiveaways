# -*- encoding : utf-8 -*-
class CreateFacebookPages < ActiveRecord::Migration
  def change
    create_table :facebook_pages do |t|
      t.string   :name
      t.string   :category
      t.string   :pid
      t.string   :token
      t.string   :avatar
      t.text     :description
      t.integer  :likes
      t.string   :url
      t.timestamps
    end
  end
end
