# -*- encoding : utf-8 -*-
class EntriesController < ApplicationController

  before_filter :before_entry_callbacks, only: [:create]
  after_filter  :after_entry_callbacks, only: [:create]

  def create
    Rails.logger.debug("EntriesController#create: params".inspect.magenta)
    Rails.logger.debug(params.inspect.yellow)
    @entry = @giveaway.entries.new

    if params[:access_token]
      Rails.logger.debug("EntriesController#create: @entry before .process".inspect.magenta)
      Rails.logger.debug(@entry.inspect.green)
      @entry = @entry.process(
        has_liked: params[:has_liked],
        referrer_id: params[:ref_id],
        access_token: params[:access_token],
        email: params[:email],
        giveaway_id: @giveaway.id,
        cookie: @giveaway_cookie
      )

      Rails.logger.debug("EntriesController#create: @entry after .process".inspect.magenta)
      Rails.logger.debug(@entry.inspect.red)



      if @entry.persisted?
        @giveaway_cookie.entry_id = @entry.id
        if @giveaway.allow_multi_entries.truthy?
          @entry.update_attributes(entry_count: @entry.entry_count += 1)
          render json: @entry.id, status: :created
          ga_event("Entries", "Entry#multi", @entry.giveaway.title, @entry.id)
        else
          render json: @entry.as_json(only: [:id, :wall_post_count, :request_count]), status: :not_acceptable
        end
      elsif @entry.status == "incomplete"
        render json: @entry.id, status: :precondition_failed
      elsif @entry.save
        @giveaway_cookie.entry_id = @entry.id
        render json: @entry.id, status: :created
        ga_event("Entries", "Entry#create", @entry.giveaway.title, @entry.id)
      else
        @delete_cookie = false
        head :not_acceptable
      end
    else
      @delete_cookie = false
      head :failed_dependency
    end
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      render text: @entry.id, status: :accepted
      ga_event("Entries", "Entry#update", @entry.id, nil)
    else
      head :not_acceptable
    end
  end

  private

  def before_entry_callbacks
    assign_giveaway
    assign_giveaway_cookie
  end

  def after_entry_callbacks
    register_like_from_entry
    @giveaway_cookie = GiveawayCookie.new if @delete_cookie
    set_giveaway_cookie
  end

  def assign_giveaway
    @giveaway = Giveaway.find(params[:giveaway_id])
  end

  def assign_giveaway_cookie
    @giveaway_cookie = GiveawayCookie.new( cookies.encrypted[Giveaway.cookie_key(@giveaway.id)] )
  end

  def register_like_from_entry
    if @like = Like.find_by_fb_uid_and_giveaway_id(@entry.uid, @entry.giveaway_id)
      Rails.logger.debug("@like fb_uid".inspect.green)
      Rails.logger.debug(@like.inspect.red)
      Rails.logger.debug(@entry.inspect.red)
      @like.update_attributes(
        entry_id: @giveaway_cookie.entry_id,
        from_entry: true
      )
      Rails.logger.debug(@like.inspect.red)
      Rails.logger.debug(@entry.inspect.red)
    elsif @like = Like.find_by_id(params[:like_id])
      Rails.logger.debug("@like params[:like_id]".inspect.green)
      Rails.logger.debug(@like.inspect.red)
      Rails.logger.debug(@entry.inspect.red)
      @like.update_attributes(
        entry_id: @giveaway_cookie.entry_id,
        from_entry: true,
        fb_uid: @entry.uid
      )
      Rails.logger.debug(@like.inspect.red)
      Rails.logger.debug(@entry.inspect.red)
    end
  end

  def set_giveaway_cookie
    cookies.encrypted[Giveaway.cookie_key(@giveaway.id)] = @giveaway_cookie.to_json
  end
end
