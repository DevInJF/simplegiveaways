class LikesController < ApplicationController

  def create
    if Like.create(params[:like])
      head :ok
    else
      head :not_acceptable
    end
  end
end
