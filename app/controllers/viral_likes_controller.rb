class ViralLikesController < ApplicationController

  def create
    if ViralLike.create(params[:viral_like])
      head :ok
    else
      head :not_acceptable
    end
  end
end
