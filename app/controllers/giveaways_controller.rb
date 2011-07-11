class GiveawaysController < ApplicationController
  
  respond_to :html, :xml, :json
  
  before_filter :authenticate_user!, :except => [:tab]
  #skip_before_filter :verify_authenticity_token, :only => [:tab]
  
  # GET /giveaways
  def index
    respond_with(@giveaways = Giveaway.all)
  end
  
  # GET /giveaways/1
  # GET /giveaways/1.xml
  def show
    respond_with(@giveaway = Giveaway.find(params[:id]))
  end

  # GET /giveaways/new
  # GET /giveaways/new.xml
  def new
    respond_with(@giveaway = Giveaway.new)
  end

  # GET /giveaways/1/edit
  def edit
    @giveaway = Giveaway.find(params[:id])
  end

  # POST /giveaways
  # POST /giveaways.xml
  def create
    @giveaway = current_user.giveaways.create(params[:giveaway])

    respond_to do |format|
      if @giveaway.save
        flash[:success] = 'Giveaway was successfully created.'
        format.html { redirect_to @giveaway }
        format.xml  { render :xml => @giveaway, :status => :created, :location => @giveaway }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @giveaway.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /giveaways/1
  # PUT /giveaways/1.xml
  def update
    @giveaway = Giveaway.find(params[:id])

    respond_to do |format|
      if @giveaway.update_attributes(params[:giveaway])
        format.html { redirect_to(@giveaway, :notice => 'Giveaway was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @giveaway.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /giveaways/1
  # DELETE /giveaways/1.xml
  def destroy
    @giveaway = Giveaway.find(params[:id])
    @giveaway.destroy

    respond_to do |format|
      format.html { redirect_to(giveaways_url, :notice => 'Giveaway was successfully destroyed.') }
      format.xml  { head :ok }
    end
  end
  
  # GET /giveaways/tab.html
  # POST /giveaways/tab.html
  def tab
    if params[:signed_request]
      @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      @signed_request = @oauth.parse_signed_request(params[:signed_request])
    end

    if @signed_request
      @giveaway = FacebookPage.find_by_pid(@signed_request["page"]["id"]).giveaways.detect(&:is_live?)
    else
      @giveaway = Giveaway.first
    end

    if params[:session_key]
      @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      oauth_access_token = @oauth.get_token_from_session_key(params[:session_key])
      graph = Koala::Facebook::GraphAPI.new(oauth_access_token)
      @profile = graph.get_object("me")
      render :json => @profile
    else
      render :layout => "tab"
    end
  end

  # POST /giveaways/1/manual_start
  def manual_start
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.is_installed?
      if @giveaway.update_attributes(:start_date => DateTime.now)
        flash["success"].now = "Giveaway has been successfully started."
        render :show
      else
        flash["error"].now = "Giveaway could not be started."
        render :show
      end
    else
      if @giveaway.update_attributes(:start_date => DateTime.now)
        redirect_to "http://www.facebook.com/add.php?api_key=5c6a416e3977373387e4767dc24cea0f&pages=1&page=#{@giveaway
      .facebook_page.pid}"
      else
        flash["error"].now = "Giveaway could not be started."
        render :show
      end
    end
  end

  # POST /giveaways/1/manual_end
  def manual_end
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.update_attributes(:end_date => DateTime.now)
      flash["success"] = "Giveaway has been successfully ended."
      redirect_to @giveaway
    else
      flash["error"].now = "Giveaway could not be ended."
      render :show
    end
  end
end
