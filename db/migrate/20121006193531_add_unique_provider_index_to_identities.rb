class AddUniqueProviderIndexToIdentities < ActiveRecord::Migration
  def change
    add_index :identities, [:provider, :user_id], unique: true
  end
end
