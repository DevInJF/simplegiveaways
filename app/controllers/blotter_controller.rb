class BlotterController < ApplicationController

  def index
    @blotter = Blotter.new(request)
    binding.remote_pry
    head :ok
  end
end
