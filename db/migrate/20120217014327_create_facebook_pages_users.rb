# -*- encoding : utf-8 -*-
class CreateFacebookPagesUsers < ActiveRecord::Migration
  def change
    create_table :facebook_pages_users, id: false do |t|
      t.integer :facebook_page_id, null: false
      t.integer :user_id,          null: false
    end
  end
end
