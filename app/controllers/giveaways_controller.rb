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
      @signed_request = Facebook::SignedRequest::parse_signed_request(params[:signed_request],"da7dc60be4b02073a6b584722896e6c9")
    end

    if params[:session]
      @session = Facebook::SignedRequest::parse_signed_request(params[:session],"da7dc60be4b02073a6b584722896e6c9")
    end

    if @signed_request
      @giveaway = FacebookPage.find_by_pid(@signed_request["page"]["id"]).giveaways.detect(&:is_live?)
    else
      @giveaway = Giveaway.first
    end

    render :layout => "tab"
  end

  # POST /giveaways/1/manual_start
  def manual_start
    @giveaway = Giveaway.find(params[:id])
    if @giveaway.update_attributes(:start_date => DateTime.now)
      redirect_to "http://www.facebook.com/add.php?api_key=5c6a416e3977373387e4767dc24cea0f&pages=1&page=#{@giveaway
    .facebook_page.pid}"
    else
      render :show
    end
  end

  # POST /giveaways/1/manual_end
  def manual_end
    @giveaway = Giveaway.find(params[:id])
    @giveaway.update_attributes(:end_date => DateTime.now)
    redirect_to @giveaway
  end
end
