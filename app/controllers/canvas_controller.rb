require 'net/http'
require 'open-uri'

class CanvasController < ApplicationController

  skip_before_filter :verify_authenticity_token


  def index
    if params["request_ids"]
      graph = Koala::Facebook::API.new(FB_APP_TOKEN)
      request = graph.get_object(params["request_ids"])

      @giveaway_url = Giveaway.select("id, giveaway_url")
                              .find_by_id(JSON.parse(request["data"])["giveaway_id"])
                              .giveaway_url

      @app_data = { :request_ids => [params["request_ids"]].compact.flatten || [],
                    :referrer_id => JSON.parse(request["data"])["referrer_id"] }

      render "giveaways/apprequest", :layout => false
    else
      redirect_to "http://simplegiveawayapp.com"
    end
  end
end