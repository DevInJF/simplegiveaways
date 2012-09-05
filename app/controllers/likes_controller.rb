class LikesController < ApplicationController

  before_filter :assign_giveaway_cookie, only: [:create]

   after_filter :set_giveaway_cookie, only: [:create]

  def create
    Rails.logger.debug("LikesController#create: params".inspect.magenta)
    Rails.logger.debug(params.inspect.yellow)
    Rails.logger.debug("LikesController#create: @giveaway_cookie".inspect.magenta)
    Rails.logger.debug(@giveaway_cookie.inspect.green)
    if @like = Like.create_from_cookie(@giveaway_cookie)
      Rails.logger.debug("Like.create_from_cookie".inspect.cyan)
      @giveaway_cookie.is_fan = true
      @giveaway_cookie.like_counted = true
      head :ok
      ga_event("Likes", "Like#create", @like.giveaway.title, @like.id)
    else
      head :not_acceptable
    end
  end

  private

  def assign_giveaway_cookie
    @giveaway_cookie = GiveawayCookie.new( cookies.encrypted[Giveaway.cookie_key(params[:like][:giveaway_id])] )
  end

  def set_giveaway_cookie
    key = Giveaway.cookie_key(params[:like][:giveaway_id])
    cookies.encrypted[key] = @giveaway_cookie.to_json
  end
end
