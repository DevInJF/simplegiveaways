# -*- encoding : utf-8 -*-
require 'net/http'
require 'open-uri'

class CanvasController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    if params["request_ids"]

      request_ids = [params["request_ids"].split(",")].compact.flatten

      graph = Koala::Facebook::API.new(FB_APP_TOKEN)
      request = graph.get_object(request_ids.last)

      @giveaway_url = Giveaway.select("id, giveaway_url")
                              .find_by_id(JSON.parse(request["data"])["giveaway_id"])
                              .giveaway_url

      @app_data = "ref_#{JSON.parse(request['data'])['referrer_id']}"

      Giveaway.delete_app_request(request_ids.last, params[:signed_request])

      render "giveaways/apprequest", :layout => false
    else
      redirect_to "http://simplegiveawayapp.com"
    end
  end
end
