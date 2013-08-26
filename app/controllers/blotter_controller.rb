class BlotterController < ApplicationController

  blotter

  def index
    render text: @blotter.view.inspect
  end
end
