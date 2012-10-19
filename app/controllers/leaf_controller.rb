class LeafController < ApplicationController

  before_filter :assign_leaf
  after_filter  :set_leaf_cookie

  def index
    if @leaf
      render json: @leaf.visitor.became_page_fan?
    else
      render text: params.inspect
    end
  end

  private

  def assign_leaf
    @leaf ||= Leaf.new(request)
  end

  def set_leaf_cookie
    if @leaf.page
      cookies.signed["_leaf_#{FB_APP_ID}_#{@leaf.page.id}"] = @leaf.outbound_cookie
    end
  end
end