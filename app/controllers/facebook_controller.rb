# -*- encoding : utf-8 -*-
class FacebookController < ApplicationController

  def parse_signed_request
    oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    @signed_request = oauth.parse_signed_request(params[:signed_request])
  end

  def register_impression
    message = @signed_request['user_id'] ? "fb_uid: #{@signed_request['user_id']}" : ""
    message += ", ref_id: #{@giveaway_hash.referrer_id}" if @giveaway_hash.referrer_id.is_a?(String)

    puts message.inspect.green

    impressionist @giveaway, message: message, unique: [:session_hash]
  end

  def last_giveaway_cookie
    cookies.encrypted[Giveaway.cookie_key(@giveaway.id)] rescue nil
  end

  def set_giveaway_cookie
    if @giveaway_hash && @giveaway_hash.giveaway
      key = Giveaway.cookie_key(@giveaway_hash.giveaway.id)
      cookies.encrypted[key] = @giveaway_cookie.to_json
    end
  end
end
