# -*- encoding : utf-8 -*-
class EntriesController < ApplicationController

  before_filter :assign_giveaway, only: [:create]
  before_filter :assign_giveaway_cookie, only: [:create]

  after_filter  :set_giveaway_cookie, only: [:create]
  after_filter  :register_like_from_entry, only: [:create]

  def create
    @entry = @giveaway.entries.new
    Rails.logger.debug(params[:ref_id].inspect.white)
    if params[:access_token]
      @entry = @entry.process(
        has_liked: params[:has_liked],
        referrer_id: params[:ref_id],
        access_token: params[:access_token],
        giveaway_id: @giveaway.id,
        cookie: @giveaway_cookie
      )

      if @entry.persisted?
        render json: @entry.as_json(only: [:id, :wall_post_count, :request_count]), status: :not_acceptable
      elsif @entry.status == "incomplete"
        render json: @entry.id, status: :precondition_failed
      elsif @entry.save
        @giveaway_cookie.entry_id = @entry.id
        render json: @entry.id, status: :created
      else
        head :not_acceptable
      end
    else
      head :failed_dependency
    end
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      render text: @entry.id, status: :accepted
    else
      head :not_acceptable
    end
  end

  private

  def assign_giveaway
    @giveaway = Giveaway.find(params[:giveaway_id])
  end

  def assign_giveaway_cookie
    @giveaway_cookie = GiveawayCookie.new( cookies.encrypted[Giveaway.cookie_key(@giveaway.id)] )
  end

  def register_like_from_entry
    if @like = Like.find_by_fb_uid_and_giveaway_id(@entry.uid, @entry.giveaway_id)
      logger.debug(@like.inspect.yellow)
      @like.update_attributes(
        entry_id: @entry.id,
        from_entry: true
      ) unless @like.entry_id.present?
    end
  end

  def set_giveaway_cookie
    cookies.encrypted[Giveaway.cookie_key(@giveaway.id)] = @giveaway_cookie.to_json
  end
end
