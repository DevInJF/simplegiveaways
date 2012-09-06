class AddIsViralFlagToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :is_viral, :boolean, default: false
  end
end
