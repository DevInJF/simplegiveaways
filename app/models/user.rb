# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :name, :roles, :roles_mask, :finished_onboarding

  has_many :identities, dependent: :destroy
  has_and_belongs_to_many :facebook_pages

  belongs_to :subscription

  delegate :next_plan, to: :subscription
  delegate :next_plan_id, to: :subscription

  include SubscriptionStatus

  include Stripe::Callbacks

  after_customer_updated! do |customer, event|
    user = User.find_by_stripe_customer_id(customer.id)
    if customer.delinquent
      user.account_current = false
    else
      user.account_current = true
    end
    user.save!
  end

  def has_free_trial_remaining?
    false
  end

  def stripe_customer(stripe_token = nil)
    if stripe_customer_id
      Stripe::Customer.retrieve(stripe_customer_id)
    elsif stripe_token
      create_customer(stripe_token)
    end
  end

  def create_customer(stripe_token)
    customer = Stripe::Customer.create(
      email: email,
      card: stripe_token
    )
    self.stripe_customer_id = customer.id
    save ? customer : false
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
