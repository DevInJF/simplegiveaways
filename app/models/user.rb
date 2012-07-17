# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  has_many :identities, :dependent => :destroy
  has_and_belongs_to_many :facebook_pages

  def avatar
    identities.find(:all, :order => "logged_in_at desc", :limit => 1).first.avatar
  end

  def fb_token
    identities.where("provider = ?", "facebook").first.token
  end

  ROLES = %w[superadmin admin team restricted banned]

  def is?(role)
    roles.include?(role.to_s)
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
end
