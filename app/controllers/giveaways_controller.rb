# -*- encoding : utf-8 -*-
class GiveawaysController < ApplicationController

  layout 'facebook_pages'

  load_and_authorize_resource :facebook_page, except: [:tab]
  load_and_authorize_resource :giveaway, through: :facebook_page, except: [:tab]

  before_filter :assign_page, only: [:active, :pending, :completed, :new, :create]
  before_filter :assign_giveaway, only: [:edit, :update, :destroy, :start, :end, :export_entries]

  after_filter  :register_impression, only: [:tab]
  after_filter  :set_giveaway_cookie, only: [:tab]

  def index
    @giveaways = Giveaway.all
  end

  def active
    @giveaway = @page.active_giveaway
    @entries = @giveaway.entries.sort_by(&:created_at).reverse.first(50) rescue []
    @flot = flot_hash
  end

  def pending
    @giveaways = @page.giveaways.pending
  end

  def completed
    @giveaways = (@page.giveaways.completed | @page.giveaways.to_end).sort_by(&:end_date).reverse
  end

  def show
    @giveaway = Giveaway.find_by_id(params[:id])
    @page = @giveaway.facebook_page
    if @giveaway.active?
      redirect_to active_facebook_page_giveaways_path(@page)
    elsif @giveaway.completed?
      @entries = @giveaway.entries.sort_by(&:created_at).reverse.first(50)
      @flot = flot_hash
    end
  end

  def new
    @giveaway = @page.giveaways.build
  end

  def edit
    @page = @giveaway.facebook_page
    if @giveaway.completed?
      redirect_to facebook_page_path(@page)
    end
  end

  def create
    giveaway_params = params[:giveaway].each do |key, value|
      value.squish! if value.class.name == "String"
    end

    @giveaway = @page.giveaways.build(giveaway_params)
    @giveaway.giveaway_url = "#{@page.url}?sk=app_#{FB_APP_ID}&ref=ts"

    if @giveaway.save
      ga_event("Giveaways", "Giveaway#create", @giveaway.title, @giveaway.id)
      flash[:info] = "The #{@giveaway.title} giveaway has been created."
      if @page.needs_subscription? && @giveaway.start_date
        redirect_to facebook_page_subscription_plans_path(@page, scheduling: true)
      else
        redirect_to pending_facebook_page_giveaways_path(@page)
      end
    else
      flash.now[:error] = "There was a problem creating #{@giveaway.title}."
      render :new
    end
  end

  def update
    @page = @giveaway.facebook_page

    if @giveaway.update_attributes(params[:giveaway])
      if @page.needs_subscription? && @giveaway.start_date
        redirect_to facebook_page_subscription_plans_path(@page, scheduling: true)
      else
        flash[:info] = "The #{@giveaway.title} giveaway has been updated."
        redirect_to facebook_page_giveaway_url(@page, @giveaway)
        @giveaway.update_tab if @giveaway.active?
      end
    else
      flash.now[:error] = "There was a problem updating #{@giveaway.title}."
      @giveaway.reload
      render :edit
    end
  end

  def destroy
    if @giveaway.destroy
      flash[:info] = "The #{@giveaway.title} giveaway has been permanently deleted."
      redirect_to facebook_page_giveaways_url(@giveaway.facebook_page)
    else
      flash.now[:error] = @giveaway.errors.messages.to_s
      render :show
    end
  end

  def start
    if @giveaway.publish(params[:giveaway])
      flash[:info] = "#{@giveaway.title} is now active on your Facebook Page.&nbsp;&nbsp;<a href='#{@giveaway.giveaway_url}' target='_blank' class='btn btn-mini'>Click here</a> to view the live giveaway.".html_safe
      redirect_to active_facebook_page_giveaways_url(@giveaway.facebook_page)
    else
      flash[:error] = "There was a problem activating #{@giveaway.title}."
      redirect_to facebook_page_giveaway_url(@giveaway.facebook_page, @giveaway)
    end
  end

  def end
    if @giveaway.unpublish
      flash[:info] = "#{@giveaway.title} has been ended and will no longer accept entries."
      redirect_to completed_facebook_page_giveaways_path(@giveaway.facebook_page)
    else
      @giveaway
      flash[:error] = "There was a problem ending #{@giveaway.title}."
      redirect_to facebook_page_giveaway_url(@giveaway.facebook_page, @giveaway)
    end
  end

  def tab
    if params[:signed_request]

      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      @signed_request = oauth.parse_signed_request(params[:signed_request])

      @giveaway_hash = Giveaway.tab(@signed_request)

      if @giveaway_hash.giveaway.nil?
        redirect_to "/404.html"
      else
        @giveaway = Giveaway.find_by_id(@giveaway_hash.giveaway.id)

        GiveawayUniquesWorker.perform_async(@giveaway.id) if last_giveaway_cookie.nil?

        @giveaway_cookie = GiveawayCookie.new(last_giveaway_cookie)
        @giveaway_cookie.giveaway_id = @giveaway.id
        @giveaway_cookie.update_cookie(@giveaway_hash)

        if @giveaway_cookie.uncounted_like
          if Like.create_from_cookie(@giveaway_cookie)
            @giveaway_cookie.like_counted = true
          end
        end

        ga_event("Giveaways", "Giveaway#tab", @giveaway.title, @giveaway.id)
        render layout: "tab"
      end

    else
      redirect_to "/500.html"
    end
  end

  def export_entries
    return false unless send_data(@giveaway.csv, type: 'text/csv', filename: 'entries_export.csv')
    ga_event("Giveaways", "Giveaway#export_entries", @giveaway.title, @giveaway.id)
  end

  private

  def assign_page
    @page = FacebookPage.find_by_id(params[:facebook_page_id])
  end

  def assign_giveaway
    @giveaway = Giveaway.find_by_id(params[:id])
  end

  def flot_hash
    giveaways_graph = Graph.new(@giveaway)
    { page_likes: giveaways_graph.page_likes,
      net_likes: giveaways_graph.net_likes,
      entries:   giveaways_graph.entries,
      views:     giveaways_graph.views }
  rescue StandardError
    {}
  end

  def register_impression
    @message = @signed_request["user_id"] ? "fb_uid: #{@signed_request['user_id']} " : ""
    @message += "ref_id: #{@giveaway_hash.referrer_id}" if @giveaway_hash.referrer_id.is_a?(String)
    if @signed_request["user_id"]
      impressionist(@giveaway, message: "#{@message}")
    else
      impressionist(@giveaway, message: "#{@message}", unique: [:session_hash])
    end
  end

  def last_giveaway_cookie
    cookies.encrypted[Giveaway.cookie_key(@giveaway.id)] rescue nil
  end

  def set_giveaway_cookie
    if @giveaway_hash && @giveaway_hash.giveaway
      key = Giveaway.cookie_key(@giveaway_hash.giveaway.id)
      cookies.encrypted[key] = @giveaway_cookie.to_json
    end
  end
end

