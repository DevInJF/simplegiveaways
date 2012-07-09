# -*- encoding : utf-8 -*-
require 'csv'

class GiveawaysController < ApplicationController

  load_and_authorize_resource :facebook_page, :except => [:tab]
  load_and_authorize_resource :giveaway, :through => :facebook_page, :except => [:tab]

  def index
    @giveaways = Giveaway.all
  end

  def active
    @page = FacebookPage.find(params[:facebook_page_id])
    @giveaways = @page.giveaways.active.first
  end

  def pending
    @page = FacebookPage.find(params[:facebook_page_id])
    @giveaways = @page.giveaways.pending
  end

  def completed
    @page = FacebookPage.find(params[:facebook_page_id])
    @giveaways = @page.giveaways.completed
  end

  def show
    @giveaway ||= Giveaway.find(params[:id])
    @page = @giveaway.facebook_page
  end

  def new
    @page = FacebookPage.find(params[:facebook_page_id])
    @giveaway = @page.giveaways.build
  end

  def edit
    @giveaway = Giveaway.find(params[:id])
  end

  def create
    @page = FacebookPage.find(params[:facebook_page_id])

    giveaway_params = params[:giveaway].each do |key, value|
      value.squish! if value.class.name == "String"
    end

    @giveaway = @page.giveaways.build(giveaway_params)
    @giveaway.giveaway_url = "#{@page.url}?sk=app_#{FB_APP_ID}"

    if @giveaway.save
      flash[:success] = "The #{@giveaway.title} giveaway has been created."
      redirect_to pending_facebook_page_giveaways_path(@page)
    else
      render :action => :new
    end
  end

  def update
    @giveaway = Giveaway.find(params[:id])

    giveaway_params = params[:giveaway].each do |key, value|
      value.squish! if value.class.name == "String"
    end

    if @giveaway.update_attributes(giveaway_params)
      flash[:success] = "The #{@giveaway.title} giveaway has been updated."
      redirect_to facebook_page_giveaway_url(@giveaway.facebook_page, @giveaway)
    else
      flash[:error] = "There was a problem updating #{@giveaway.title}."
      redirect_to facebook_page_giveaway_url(@giveaway.facebook_page, @giveaway)
    end
  end

  def destroy
    @giveaway = Giveaway.find(params[:id])

    if @giveaway.destroy
      flash[:success] = "The #{@giveaway.title} giveaway has been permanently deleted."
      redirect_to facebook_page_giveaways_url(@giveaway.facebook_page)
    else
      flash.now[:error] = @giveaway.errors.messages.to_s
      render :show
    end
  end

  def start
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.publish(params[:giveaway])
      flash[:success] = "#{@giveaway.title} is now active on your Facebook Page.&nbsp;&nbsp;<a href='#{@giveaway.giveaway_url}' target='_blank' class='btn btn-mini'>Click here</a> to view the live giveaway.".html_safe
      redirect_to active_facebook_page_giveaways_url(@giveaway.facebook_page)
    else
      flash.now[:error] = "There was a problem activating #{@giveaway.title}."
      logger.debug(@giveaway.errors.inspect.red_on_white)
      redirect_to facebook_page_giveaways_url(@giveaway.facebook_page)
    end
  end

  def end
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.update_attributes(:end_date => DateTime.now, :active => false)
      flash[:success] = "#{@giveaway.title} has been ended and will no longer accept entries."
      redirect_to completed_facebook_page_giveaways_path(@giveaway.facebook_page)
      @giveaway.delete_tab
    else
      flash.now[:error] = "There was a problem ending #{@giveaway.title}."
      render :show
    end
  end

  def tab
    if params[:signed_request]
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request = oauth.parse_signed_request(params[:signed_request])

      @giveaway = Giveaway.tab(signed_request)

      if @giveaway.giveaway.nil?
        redirect_to "/404.html"
      else
        @message = @giveaway.referrer_id.present? ? "ref_id: #{@giveaway.referrer_id}" : nil
        impressionist(@giveaway.giveaway, message: "#{@message}", :filter=>:session_hash)
        render :layout => "tab"
      end

    else
      redirect_to "/500.html"
    end
  end

  def export_entries
    @giveaway = Giveaway.find(params[:id])
    @entries = @giveaway.entries
  
    entries_csv = CSV.generate do |csv|
      # header row
      csv << ["ID", "email", "Name", "Entry Time", "Wall Posts", "Requests", "Conversions"]

      # data rows
      @entries.each do |entry|
        csv << [entry.id, entry.email, entry.name, entry.datetime_entered, entry.wall_post_count, entry.request_count, entry.convert_count]
      end
    end
     
    send_data(entries_csv, :type => 'text/csv', :filename => 'entries_export.csv')
  end
end

