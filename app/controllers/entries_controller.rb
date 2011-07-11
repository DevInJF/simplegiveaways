class EntriesController < ApplicationController
  
  respond_to :html, :xml, :json  
  
  before_filter :authenticate_user!, :except => [:tab]
  
  def index
    @entries = Entry.all
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def create
    @giveaway = Giveaway.find_by_facebook_page_id(params[:id])
    @entry = @giveaway.entries.new

    if params[:session_key]
      @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      oauth_access_token = @oauth.get_token_from_session_key(params[:session_key])

      graph = Koala::Facebook::GraphAPI.new(oauth_access_token)
      @profile = graph.get_object("me")

      uid = @profile["id"]

      if Entry.like_status(@giveaway.facebook_page.pid, uid) == false
        status = "incomplete"
      else
        status = "complete"
      end

      @entry.create(
        :uid => uid,
        :name => @profile["name"],
        :email => @profile["email"],
        :fb_url => @profile["link"],
        :datetime_entered => DateTime.now,
        :status => status
      )

      render :json => @profile
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
