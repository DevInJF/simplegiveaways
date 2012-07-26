class LikesController < ApplicationController

  before_filter :assign_giveaway_cookie, only: [:create]

  def create
    Rails.logger.debug("LIKESCONTROLLER\n\n\n\n\AAAAH".inspect.white)
    if Like.create_from_cookie(@giveaway_cookie)
      head :ok
    else
      head :not_acceptable
    end
  end

  private

  def assign_giveaway_cookie
    @giveaway_cookie = GiveawayCookie.new( cookies[Giveaway.cookie_key(params[:giveaway_id])] )
  end
end
