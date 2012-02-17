# -*- encoding : utf-8 -*-
class EntriesController < ApplicationController
  
  respond_to :html, :xml, :json  
  
  before_filter :authenticate_user!, :except => [:create, :update]
  
  def index
    @entries = Entry.all
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def create
    @giveaway = Giveaway.find(params[:giveaway_id])
    entry = @giveaway.entries.new

    if params[:access_token]
      @entry = entry.build_from_session(@giveaway, params[:access_token], params[:has_liked], params[:ref_id])
      if @entry.persisted?
        render :json => @entry.as_json(:only => [:id, :share_count, :request_count]), :status => :not_acceptable
      elsif @entry.status == "incomplete"
        render :json => @entry.id, :status => :precondition_failed
      elsif @entry.save
        render :json => @entry.id, :status => :created
      end
    else
      head :failed_dependency
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      render :text => @entry.id, :status => :accepted
    else
      head :not_acceptable
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    redirect_to entries_url, :notice => "Successfully destroyed entry."
  end
end
