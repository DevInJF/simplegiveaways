class AddAccountCurrentUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_current, :boolean, default: true
  end
end
