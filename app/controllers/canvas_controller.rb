# -*- encoding : utf-8 -*-
require 'net/http'
require 'open-uri'

class CanvasController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    if params["request_ids"]

      @request_ids = [params["request_ids"].split("%2C").split(",")].compact.flatten

      @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)

      if @request = select_request

        @giveaway = Giveaway.select("id, title, giveaway_url").find_by_id(JSON.parse(@request["data"])["giveaway_id"])
        @app_data = "ref_#{JSON.parse(@request['data'])['referrer_id']}"

        FbAppRequestWorker.perform_async(@request, params[:signed_request])

        render "giveaways/apprequest", layout: false
        ga_event("Canvas", "Canvas#index", @giveaway.title, JSON.parse(@request['data'])['referrer_id'].to_i)
      else
        redirect_to "http://facebook.com"
      end
    else
      redirect_to "http://facebook.com"
    end
  end

  private

  def select_request
    @graph.get_object(@request_ids.pop)
  rescue StandardError
    @graph.get_object(@request_ids.pop)
  rescue StandardError
    @graph.get_object(@request_ids.pop)
  rescue StandardError
    false
  end
end
