class AddFinishedOnboardingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :finished_onboarding, :boolean, default: false
  end
end
