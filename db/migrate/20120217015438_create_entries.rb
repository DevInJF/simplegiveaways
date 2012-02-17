# -*- encoding : utf-8 -*-
class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries, :force => true do |t|
      t.string   :email
      t.boolean  :has_liked,        :default => false
      t.string   :name
      t.string   :fb_url
      t.datetime :datetime_entered
      t.integer  :share_count,      :default => 0
      t.integer  :request_count,    :default => 0
      t.integer  :convert_count,    :default => 0
      t.integer  :giveaway_id
      t.string   :status
      t.string   :uid
      t.timestamps
    end

    add_index :entries, [:email, :giveaway_id], :unique => true
  end
end
