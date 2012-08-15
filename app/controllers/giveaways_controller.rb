# -*- encoding : utf-8 -*-
class GiveawaysController < ApplicationController

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
    @giveaways = @page.giveaways.active.first rescue nil
    @flot = { page_likes: Graph.new(@page).page_likes,
              net_likes: Graph.new(@giveaways).net_likes,
              entries: Graph.new(@giveaways).entries,
              views: Graph.new(@giveaways).views }
  end

  def pending
    @giveaways = @page.giveaways.pending
  end

  def completed
    @giveaways = @page.giveaways.completed
  end

  def show
    @giveaway = Giveaway.find_by_id(params[:id])
    @page = @giveaway.facebook_page
    @flot = { page_likes: Graph.new(@page).page_likes,
              net_likes: Graph.new(@page).net_likes,
              entries: Graph.new(@giveaway).entries,
              views: Graph.new(@giveaway).views }
  end

  def new
    @giveaway = @page.giveaways.build
  end

  def edit
    @page = @giveaway.facebook_page
  end

  def create
    giveaway_params = params[:giveaway].each do |key, value|
      value.squish! if value.class.name == "String"
    end

    @giveaway = @page.giveaways.build(giveaway_params)
    @giveaway.giveaway_url = "#{@page.url}?sk=app_#{FB_APP_ID}"

    if @giveaway.save
      ga_event("Giveaways", "#create", @giveaway.title, @giveaway.id)
      flash[:success] = "The #{@giveaway.title} giveaway has been created."
      redirect_to pending_facebook_page_giveaways_path(@page)
    else
      flash.now[:error] = "There was a problem creating #{@giveaway.title}."
      render :new
    end
  end

  def update
    @giveaway_params = params[:giveaway].reject do |key, value|
      value.squish! if value.is_a?(String)
      key == "start_date"
    end

    if @giveaway.update_attributes(@giveaway_params)
      flash[:success] = "The #{@giveaway.title} giveaway has been updated."
      redirect_to facebook_page_giveaway_url(@giveaway.facebook_page, @giveaway)
      @giveaway.update_tab if @giveaway.active?
    else
      logger.debug(@giveaway.errors.inspect.green_on_red)
      flash.now[:error] = "There was a problem updating #{@giveaway.title}."
      @giveaway.reload
      render :show
    end
  end

  def destroy
    if @giveaway.destroy
      flash[:success] = "The #{@giveaway.title} giveaway has been permanently deleted."
      redirect_to facebook_page_giveaways_url(@giveaway.facebook_page)
    else
      flash.now[:error] = @giveaway.errors.messages.to_s
      render :show
    end
  end

  def start
    logger.debug(params.inspect.red_on_white)
    if @giveaway.publish(params[:giveaway])
      ga_event("Giveaways", "#start", @giveaway.title, @giveaway.id)
      flash[:success] = "#{@giveaway.title} is now active on your Facebook Page.&nbsp;&nbsp;<a href='#{@giveaway.giveaway_url}' target='_blank' class='btn btn-mini'>Click here</a> to view the live giveaway.".html_safe
      redirect_to active_facebook_page_giveaways_url(@giveaway.facebook_page)
      GiveawayNoticeMailer.start(current_user.identities.first.email).deliver
    else
      flash[:error] = "There was a problem activating #{@giveaway.title}."
      logger.debug(@giveaway.errors.inspect.red_on_white)
      redirect_to facebook_page_giveaway_url(@giveaway.facebook_page, @giveaway)
    end
  end

  def end
    if @giveaway.update_attributes(end_date: DateTime.now, active: false)
      flash[:success] = "#{@giveaway.title} has been ended and will no longer accept entries."
      redirect_to completed_facebook_page_giveaways_path(@giveaway.facebook_page)
      if @giveaway.delete_tab
        ga_event("Giveaways", "#end", @giveaway.title, @giveaway.id)
        GiveawayNoticeMailer.end(current_user.identities.first.email).deliver
      end
    else
      flash.now[:error] = "There was a problem ending #{@giveaway.title}."
      render :show
    end
  end

  def tab
    if params[:signed_request]
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request = oauth.parse_signed_request(params[:signed_request])

      @giveaway_hash = Giveaway.tab(signed_request)

      if @giveaway_hash.giveaway.nil?
        redirect_to "/404.html"
      else
        @giveaway = Giveaway.find_by_id(@giveaway_hash.giveaway.id)

        logger.debug(last_giveaway_cookie.inspect.white_on_magenta)

        @giveaway_cookie = GiveawayCookie.new(last_giveaway_cookie)
        @giveaway_cookie.giveaway_id = @giveaway.id
        @giveaway_cookie.update_cookie(@giveaway_hash)

        logger.debug(@giveaway_cookie.inspect.magenta_on_white)

        if @giveaway_cookie.uncounted_like
          if Like.create_from_cookie(@giveaway_cookie)
            @giveaway_cookie.like_counted = true
          end
        end

        ga_event("Giveaways", "#tab", @giveaway.title, @giveaway.id)

        render layout: "tab"
      end

    else
      redirect_to "/500.html"
    end
  end

  def export_entries
    return false unless send_data(@giveaway.csv, type: 'text/csv', filename: 'entries_export.csv')
    ga_event("Giveaways", "#export_entries", @giveaway.title, @giveaway.id)
  end

  private

  def assign_page
    @page = FacebookPage.find_by_id(params[:facebook_page_id])
  end

  def assign_giveaway
    @giveaway = Giveaway.find_by_id(params[:id])
  end

  def register_impression
    @message = @giveaway_hash.referrer_id.is_a?(String) ? "ref_id: #{@giveaway_hash.referrer_id}" : nil
    impressionist(@giveaway, message: "#{@message}", filter: :session_hash)
  end

  def last_giveaway_cookie
    cookies.encrypted[Giveaway.cookie_key(@giveaway.id)] rescue nil
  end

  def set_giveaway_cookie
    key = Giveaway.cookie_key(@giveaway_hash.giveaway.id)
    logger.debug(@giveaway_cookie.to_json.inspect.white_on_green)
    cookies.encrypted[key] = @giveaway_cookie.to_json
  end
end

