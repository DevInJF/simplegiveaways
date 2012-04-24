# -*- encoding : utf-8 -*-
class GiveawaysController < ApplicationController

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
    @giveaway = Giveaway.find(params[:id])
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
    @giveaway = @page.giveaways.build(params[:giveaway])

    @giveaway.giveaway_url = "#{@page.url}?sk=app_#{FB_APP_ID}"

    if @giveaway.save
      flash[:success] = "The #{@giveaway.title} giveaway has been created."
      redirect_to @page
    else
      render :action => :new
    end
  end

  def update
    @giveaway = Giveaway.find(params[:id])

    if @giveaway.update_attributes(params[:giveaway])
      flash[:success] = "The #{@giveaway.title} giveaway has been updated."
      redirect_to @giveaway
    else
      render :action => "edit"
    end
  end

  def destroy
    @giveaway = Giveaway.find(params[:id])

    if @giveaway.destroy
      flash[:success] = "The #{@giveaway.title} giveaway has been permanently deleted."
      redirect_to(giveaways_url)
    else
      flash.now[:error] = @giveaway.errors.messages.to_s
      render :action => "edit"
    end
  end

  def start
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.startable?
      if @giveaway.update_attributes(:start_date => DateTime.now)
        flash.now[:success] = "The #{@giveaway.title} giveaway is now on your Facebook Page."
      else
        flash.now[:error] = @giveaway.errors.messages.to_s
      end
      render :show
    else
      if @giveaway.is_installed?
        flash.now[:error] = "Only one giveaway can be active for each Facebook page."
        render :show
      else
        redirect_to "http://www.facebook.com/add.php?api_key=5c6a416e3977373387e4767dc24cea0f&pages=1&page=#{@giveaway.facebook_page.pid}"
      end
    end
  end

  def end
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.update_attributes(:end_date => DateTime.now)
      flash[:success] = "The #{@giveaway.title} giveaway has been ended and will no longer accept entries."
      redirect_to @giveaway
    else
      flash.now[:error] = "Giveaway could not be ended."
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
        impressionist(@giveaway.giveaway)
        render :layout => "tab"
      end
    else
      redirect_to "/500.html"
    end
  end
end
