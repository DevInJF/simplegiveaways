class Audit < ActiveRecord::Base

  belongs_to :auditable, :polymorphic => true

  serialize :was
  serialize :is
end