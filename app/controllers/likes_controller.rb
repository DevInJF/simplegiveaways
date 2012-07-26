class LikesController < ApplicationController

  before_filter :assign_giveaway_cookie, only: [:create]

   after_filter :set_giveaway_cookie, only: [:create]

  def create
    Rails.logger.debug("LIKESCONTROLLER\n\n\n\n\AAAAH".inspect.white)
    Rails.logger.debug(@giveaway_cookie.inspect.white)
    if Like.create_from_cookie(@giveaway_cookie)
      @giveaway_cookie.is_fan = true
      @giveaway_cookie.like_counted = true
      head :ok
    else
      head :not_acceptable
    end
  end

  private

  def assign_giveaway_cookie
    @giveaway_cookie = GiveawayCookie.new( cookies[Giveaway.cookie_key(params[:like][:giveaway_id])] )
  end

  def set_giveaway_cookie
    key = Giveaway.cookie_key(params[:like][:giveaway_id])
    cookies[key] = @giveaway_cookie.to_json
  end
end
