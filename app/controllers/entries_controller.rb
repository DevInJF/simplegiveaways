class EntriesController < ApplicationController
  
  respond_to :html, :xml, :json  
  
  before_filter :authenticate_user!, :except => [:create]
  
  def index
    @entries = Entry.all
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def create
    @giveaway = Giveaway.find(params[:giveaway_id])
    @entry = @giveaway.entries.new

    if params[:session_key]
      @entry.build_from_session(@giveaway, params[:session_key])

      if @entry.save
        render :json => @entry
      else
        render :text => "Entry could not be created."
      end
    else
      render :text => "Session key was not provided."
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      redirect_to @entry, :notice  => "Successfully updated entry."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    redirect_to entries_url, :notice => "Successfully destroyed entry."
  end
end
