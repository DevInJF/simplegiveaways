# -*- encoding : utf-8 -*-
class GiveawaysController < ApplicationController

  layout 'facebook_pages'

  load_and_authorize_resource :facebook_page, except: [:tab, :enter]
  load_and_authorize_resource :giveaway, through: :facebook_page, except: [:tab, :enter]

  before_filter :assign_page, only: [:active, :pending, :completed, :new, :create, :clone, :destroy]
  before_filter :assign_giveaway, only: [:edit, :update, :destroy, :start, :end, :export_entries, :clone, :destroy]

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
    @giveaway = Giveaway.find(params[:id])
    @page = @giveaway.facebook_page
    if @giveaway.active?
      flash.keep
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

      flash[:info] = "#{@giveaway.title} has been created.".html_safe

      if @page.cannot_schedule? && @giveaway.start_date
        flash[:info] += "<br /><br /><i class='info icon'></i>Scheduling giveaways requires an active Pro subscription. Since #{@page.name} does not currently meet this criteria, the giveaway schedule will be deactivated for now. If you'd like to schedule the giveaway, please <a class='ui tiny teal button' href='#{facebook_page_subscription_plans_path(@page)}'>subscribe to a Pro plan</a>. If you're not sure right now, no problem. You can choose or upgrade a plan whenever you like.".html_safe
      end

      redirect_to pending_facebook_page_giveaways_path(@page)
    else
      flash.now[:error] = "There was a problem creating #{@giveaway.title}."
      render :new
    end
  end

  def update
    @page = @giveaway.facebook_page

    if @giveaway.update_attributes(params[:giveaway])
      flash[:info] = "#{@giveaway.title} has been updated.".html_safe

      if @page.cannot_schedule? && @giveaway.start_date
        flash[:info] += "<br /><br /><i class='info icon'></i>Scheduling giveaways requires an active Pro subscription. Since #{@page.name} does not currently meet this criteria, the giveaway schedule will be deactivated for now. If you'd like to schedule the giveaway, please <a class='ui tiny teal button' href='#{facebook_page_subscription_plans_path(@page)}'>subscribe to a Pro plan</a>. If you're not sure right now, no problem. You can choose or upgrade a plan whenever you like.".html_safe
      end

      redirect_to facebook_page_giveaway_url(@page, @giveaway)
      @giveaway.update_tab if @giveaway.active?
    else
      flash.now[:error] = "There was a problem updating #{@giveaway.title}."
      @giveaway.reload
      render :edit
    end
  end

  def destroy
    if @giveaway.destroy
      flash[:info] = "#{@giveaway.title} has been permanently deleted."
      redirect_to facebook_page_url(@giveaway.facebook_page)
    else
      flash.now[:error] = @giveaway.errors.messages.to_s
      render :show
    end
  end

  def start
    session.delete(:proposed_end_date)
    session.delete(:proposed_tab_name)

    if @giveaway.publish(params[:giveaway])
      flash[:info] = "#{@giveaway.title} is now active on your Facebook Page.&nbsp;&nbsp;<a href='#{@giveaway.giveaway_url}' target='_blank' class='btn btn-mini'>Click here</a> to view the live giveaway.".html_safe
      redirect_to active_facebook_page_giveaways_url(@giveaway.facebook_page)
    else
      flash[:error] = "There was a problem publishing #{@giveaway.title}. Please try again or contact support for assistance."
      redirect_to facebook_page_giveaway_url(@giveaway.facebook_page, @giveaway)
    end
  end

  def end
    if @giveaway.unpublish
      flash[:info] = "#{@giveaway.title} has ended and will no longer accept entries."
      redirect_to completed_facebook_page_giveaways_path(@giveaway.facebook_page)
    else
      @giveaway
      flash[:error] = "There was a problem ending #{@giveaway.title}. Please try again or contact support for assistance."
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

  def enter
    @giveaway = Giveaway.find(params[:giveaway_id])
    @page = @giveaway.facebook_page
    ga_event("Giveaways", "Giveaway#enter", @giveaway.title, @giveaway.id)
    render layout: "enter"
  end

  def check_schedule
    page = FacebookPage.find(params[:facebook_page_id])
    giveaway = params[:giveaway_id].present? ? Giveaway.find(params[:giveaway_id]) : page.giveaways.build

    if params[:date_type] == 'end'
      giveaway.end_date = params[:date]
      conflicts = giveaway.end_date_conflicts
    else
      giveaway.start_date = params[:date]
      conflicts = giveaway.start_date_conflicts
    end

    if conflicts
      render json: conflicts
    else
      head :unprocessable_entity
    end
  end

  def export_entries
    return false unless send_data(@giveaway.csv, type: 'text/csv', filename: 'entries_export.csv')
    ga_event("Giveaways", "Giveaway#export_entries", @giveaway.title, @giveaway.id)
  end

  def clone
    @clone = @giveaway.dup
    @clone.title = "Copy of #{@clone.title} (#{Time.now.to_s(:short)})"
    @clone.start_date = nil
    @clone.end_date = nil

    if @clone.save
      redirect_to edit_facebook_page_giveaway_path(@page, @clone)
    else
      flash[:error] = "There was a problem cloning the giveaway. Please try again or contact support for assistance."
      redirect_to facebook_page_giveaway_path(@page, @giveaway)
    end
  end

  private

  def assign_page
    @page = if params[:facebook_page_id]
      FacebookPage.find(params[:facebook_page_id])
    elsif params[:giveaway_id]
      @giveaway ||= Giveaway.find(params[:giveaway_id])
      @giveaway.facebook_page
    end
  end

  def assign_giveaway
    @giveaway = if params[:giveaway_id]
      Giveaway.find(params[:giveaway_id])
    else
      Giveaway.find(params[:id])
    end
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

