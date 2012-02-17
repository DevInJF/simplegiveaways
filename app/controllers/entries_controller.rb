# -*- encoding : utf-8 -*-
class EntriesController < ApplicationController

  def create
    @giveaway = Giveaway.find(params[:giveaway_id])
    entry = @giveaway.entries.new

    if params[:access_token]
      @entry = entry.process(
        :has_liked => params[:has_liked],
        :referrer_id => params[:ref_id],
        :access_token => params[:access_token]
      )
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

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      render :text => @entry.id, :status => :accepted
    else
      head :not_acceptable
    end
  end
end
