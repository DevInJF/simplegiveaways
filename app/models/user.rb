# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  include Stripe::Callbacks

  attr_accessible :name, :roles, :roles_mask, :finished_onboarding

  has_many :identities, dependent: :destroy
  has_and_belongs_to_many :facebook_pages

  belongs_to :subscription

  after_customer_created! do |customer, event|
    Rails.logger.debug(customer)
    Rails.logger.debug(event)
  end

  include SubscriptionStatus

  def has_free_trial_remaining?
    false
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end

  def current_identity
    identities.find(:all, order: "logged_in_at desc", limit: 1).first
  end

  def email
    current_identity.email
  end

  def avatar
    current_identity.avatar
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

  def self.pages_worker(user_id, fb_token, csrf_token)
    graph = Koala::Facebook::API.new(fb_token)
    pages = graph.get_connections("me", "accounts")
    @user = User.find_by_id(user_id)
    FacebookPage.retrieve_fb_meta(@user, pages, csrf_token)
  end
end
