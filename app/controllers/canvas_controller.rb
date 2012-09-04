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

      Rails.logger.debug("graph: #{graph.inspect}".inspect.yellow)
      Rails.logger.debug("request: #{request.inspect}".inspect.magenta)

      @giveaway = Giveaway.select("id, title, giveaway_url").find_by_id(JSON.parse(request["data"])["giveaway_id"])
      @app_data = "ref_#{JSON.parse(request['data'])['referrer_id']}"

      Rails.logger.debug("@giveaway: #{@giveaway.inspect}".inspect.green)
      Rails.logger.debug("@app_data: #{@app_data.inspect}".inspect.red)

      FbAppRequestWorker.perform_async(request_ids.last, params[:signed_request])

      render "giveaways/apprequest", layout: false
      ga_event("Canvas", "Canvas#index", @giveaway.title, JSON.parse(request['data'])['referrer_id'].to_i)
    else
      redirect_to "http://simplegiveawayapp.com"
    end
  end
end
