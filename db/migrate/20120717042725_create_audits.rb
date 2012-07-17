class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.references  :auditable, :polymorphic => true
      t.text        :was
      t.text        :is
      t.text        :comment
      t.timestamps
    end
  end
end
