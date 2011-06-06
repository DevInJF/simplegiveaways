class GiveawaysController < ApplicationController
  
  respond_to :html, :xml, :json
  
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
    @giveaway = Giveaway.new(params[:giveaway])
    
    @giveaway.start_date = DateTime.strptime(params[:giveaway][:start_date], "%m/%d/%Y %H:%M")
    @giveaway.end_date = DateTime.strptime(params[:giveaway][:end_date], "%m/%d/%Y %H:%M")
    
    respond_to do |format|
      if @giveaway.save
        format.html { redirect_to(@giveaway, :notice => 'Giveaway was successfully created.') }
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

end
