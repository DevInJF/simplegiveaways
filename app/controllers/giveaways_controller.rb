require 'json'

class GiveawaysController < ApplicationController

  before_filter :authenticate_user!, :except => :tab

  skip_before_filter :verify_authenticity_token, :only => :tab


  def index
    @giveaways = Giveaway.all
  end

  def show
    @giveaway = Giveaway.find(params[:id], :include => [:entries])
  end

  def new
    @page = FacebookPage.find(params[:facebook_page_id])
    @giveaway = Giveaway.new
  end

  def edit
    @giveaway = Giveaway.find(params[:id])
  end

  def create
    @page = FacebookPage.find(params[:facebook_page_id])
    @giveaway = @page.giveaways.build(params[:giveaway])
    @giveaway.giveaway_url = "#{@page.url}?sk=app_#{FB_APP_ID}"

    if @giveaway.save
      flash[:success] = 'Giveaway was successfully created.'
      redirect_to @giveaway
    else
      render :action => "new"
    end
  end

  def update
    @giveaway = Giveaway.find(params[:id])

    if @giveaway.update_attributes(params[:giveaway])
      flash[:success] = 'Giveaway was successfully updated.'
      redirect_to(@giveaway)
    else
      render :action => "edit"
    end
  end

  def destroy
    @giveaway = Giveaway.find(params[:id])
    @giveaway.destroy

    flash[:success] = 'Giveaway was successfully destroyed.'
    redirect_to(giveaways_url)
  end

  def tab
    if params[:request_ids]
      if @redirect_url = Giveaway.redirect_app_request(params["request_ids"])
        Giveaway.delete_app_request(params)
        redirect_to @redirect_url
      end
    elsif params[:signed_request]

      @giveaway = Giveaway.render(params)

      if @giveaway["giveaway"].nil?
        redirect_to "/404.html"
      else
        impressionist(@giveaway["giveaway"])
        render :layout => "tab"
      end
    else
      redirect_to "/500.html"
    end
  end

  def manual_start
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.is_installed?
      if @giveaway.update_attributes(:start_date => DateTime.now)
        flash.now[:success] = "Giveaway has been successfully started."
        render :show
      else
        flash.now[:error] = "Giveaway could not be started."
        render :show
      end
    else
      if @giveaway.update_attributes(:start_date => DateTime.now)
        redirect_to "http://www.facebook.com/add.php?api_key=5c6a416e3977373387e4767dc24cea0f&pages=1&page=#{@giveaway
      .facebook_page.pid}"
      else
        flash.now[:error] = "Giveaway could not be started."
        render :show
      end
    end
  end

  def manual_end
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.update_attributes(:end_date => DateTime.now)
      flash[:success] = "Giveaway has been successfully ended."
      redirect_to @giveaway
    else
      flash.now[:error] = "Giveaway could not be ended."
      render :show
    end
  end
end
