# -*- encoding : utf-8 -*-
require 'net/http'
require 'open-uri'

class CanvasController < ApplicationController

  before_filter :giveaway_from_request, only: [:index]

  skip_before_filter :verify_authenticity_token

  def index
    if @giveaway_found
      render "giveaways/apprequest", layout: false
      ga_event("Canvas", "Canvas#index", @giveaway.title, JSON.parse(@request['data'])['referrer_id'].to_i)
    else
      redirect_to "http://facebook.com"
    end
  end

  private

  def giveaway_from_request
    if params["request_ids"]

      @request_ids = [params["request_ids"].split("%2C").split(",")].compact.flatten.pop.split(",")

      @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)

      if @request = select_request
        Rails.logger.debug(@request.inspect.green)
        @giveaway = Giveaway.select("id, title, giveaway_url").find_by_id(JSON.parse(@request["data"])["giveaway_id"])
        @app_data = "ref_#{JSON.parse(@request['data'])['referrer_id']}"

        if @giveaway
          FbAppRequestWorker.perform_async(@request, params[:signed_request])
          @giveaway_found = true
        end
      end
    end
  end

  def select_request
    Rails.logger.debug(@request_ids.inspect.magenta)
    @request_ids.map do |rid|
      Rails.logger.debug(rid.inspect.yellow)
      @graph.get_object(@request_ids.pop.to_i) rescue nil
    end.compact.pop
  rescue StandardError
    false
  end
end
