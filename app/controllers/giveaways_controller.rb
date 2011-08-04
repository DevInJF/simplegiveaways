require 'json'

class GiveawaysController < ApplicationController

  before_filter :authenticate_user!, :except => [:tab, :app_request]
  
  # GET /giveaways
  def index
    @giveaways = Giveaway.all
  end
  
  # GET /giveaways/1
  # GET /giveaways/1.xml
  def show
    @giveaway = Giveaway.find(params[:id], :include => [:entries])
  end

  # GET /giveaways/new
  # GET /giveaways/new.xml
  def new
    @page = FacebookPage.find(params[:facebook_page_id])
    @giveaway = Giveaway.new
  end

  # GET /giveaways/1/edit
  def edit
    @giveaway = Giveaway.find(params[:id])
  end

  # POST /giveaways
  # POST /giveaways.xml
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

  # PUT /giveaways/1
  # PUT /giveaways/1.xml
  def update
    @giveaway = Giveaway.find(params[:id])

    if @giveaway.update_attributes(params[:giveaway])
      flash[:success] = 'Giveaway was successfully updated.'
      redirect_to(@giveaway)
    else
      render :action => "edit"
    end
  end

  # DELETE /giveaways/1
  # DELETE /giveaways/1.xml
  def destroy
    @giveaway = Giveaway.find(params[:id])
    @giveaway.destroy

    flash[:success] = 'Giveaway was successfully destroyed.'
    redirect_to(giveaways_url)
  end
  
  # GET /giveaways/tab.html
  # POST /giveaways/tab.html
  def tab
    if params[:signed_request]
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request = oauth.parse_signed_request(params[:signed_request])

      current_page = FacebookPage.select("id, url, name").find_by_pid(signed_request["page"]["id"])

      @giveaway = {
        "app_data" => signed_request["app_data"],
        "has_liked" => signed_request["page"]["liked"],
        "request_id" => params["request_ids"],
        "current_page" => current_page,
        "giveaway" => current_page.giveaways.detect(&:is_live?)
      }

      impressionist(@giveaway["giveaway"])
      render :layout => "tab"
    else
      redirect_to "/500.html"
    end
  end

  # GET /giveaways/tab.html
  def app_request
    if params["request_ids"]

      # TODO: Check to see if we've already counted this request

      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      graph = Koala::Facebook::GraphAPI.new(oauth.get_app_access_token)

      request = graph.get_object(params["request_ids"])
      referrer = JSON.parse(request["data"])["referrer_id"]
      giveaway = Giveaway.find_by_id(JSON.parse(request["data"])["giveaway_id"])

      redirect_to "#{giveaway.giveaway_url}&app_data=ref_#{referrer}"
    else
      redirect_to "/500.html"
    end
  end

  # POST /giveaways/1/manual_start
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

  # POST /giveaways/1/manual_end
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
