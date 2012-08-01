# -*- encoding : utf-8 -*-
require 'net/http'
require 'open-uri'

class CanvasController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    if params["request_ids"]

      request_ids = [params["request_ids"].split(",")].compact.flatten

      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request = oauth.parse_signed_request(params[:signed_request])

      graph = Koala::Facebook::API.new(signed_request["oauth_token"])
      request = graph.get_object(request_ids.last)

      @giveaway = Giveaway.select("id, title, giveaway_url").find_by_id(JSON.parse(request["data"])["giveaway_id"])
      @app_data = "ref_#{JSON.parse(request['data'])['referrer_id']}"

      FbAppRequestWorker.perform_async(request_ids.last, params[:signed_request])

      render "giveaways/apprequest", layout: false
      ga_event("Canvas", "#index", @giveaway.title, @app_data.to_json)
    else
      redirect_to "http://simplegiveawayapp.com"
    end
  end
end
