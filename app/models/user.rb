# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :name, :roles, :roles_mask

  has_many :identities, dependent: :destroy
  has_and_belongs_to_many :facebook_pages

  has_many :subscriptions

  def avatar
    identities.find(:all, order: "logged_in_at desc", limit: 1).first.avatar
  end

  def fb_uid
    identities.where("provider = 'facebook'").first.uid
  end

  def fb_token
    identities.where("provider = 'facebook'").first.token
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

  def self.pages_worker(user, fb_token, csrf_token)
    graph = Koala::Facebook::API.new(fb_token)
    pages = graph.get_connections("me", "accounts")
    @user = User.find_by_id(user["id"])
    FacebookPage.retrieve_fb_meta(@user, pages, csrf_token)
  end
end
