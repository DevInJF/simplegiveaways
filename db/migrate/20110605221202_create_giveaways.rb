class CreateGiveaways < ActiveRecord::Migration
  def self.up
    create_table :giveaways do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :content
      t.boolean :is_live

      t.timestamps
    end
  end

  def self.down
    drop_table :giveaways
  end
end
