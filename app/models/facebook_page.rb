# -*- encoding : utf-8 -*-
class FacebookPage < ActiveRecord::Base

  include ActionView::Helpers::UrlHelper

  has_many :giveaways
  has_and_belongs_to_many :users

  validates :pid, :uniqueness => true

  def self.retrieve_fb_meta(user, pages)
    [pages].compact.flatten.each do |page|
      unless page["category"] == "Application"
        @graph = Koala::Facebook::API.new(page["access_token"])

        batch_data = @graph.batch do |batch_api|
          batch_api.get_object("me")
          batch_api.get_picture("me", :type => "square")
          batch_api.get_picture("me", :type => "large")
        end

        fb_meta = batch_data[0]
        fb_avatar_square = batch_data[1]
        fb_avatar_large = batch_data[2]

        if fb_meta["link"].include? "facebook.com"

          @page = FacebookPage.find_or_create_by_pid(page["id"])
          @page.update_attributes(
            :name => page["name"],
            :category => page["category"],
            :pid => page["id"],
            :token => page["access_token"],
            :avatar_square => fb_avatar_square,
            :avatar_large => fb_avatar_large,
            :description => fb_meta["description"],
            :url => fb_meta["link"],
            :likes => fb_meta["likes"],
            :has_added_app => fb_meta["has_added_app"]
          )
          Rails.logger.debug(@page.preview_template.inspect)
          Juggernaut.publish("users#show", @page.preview_template)

          unless user.facebook_pages.include? @page
            user.facebook_pages << @page
          end
        end
      end
    end
  end

  def preview_template
    <<-eos
      <div class="facebook_page_preview" data-fb-pid="#{pid}">
        <div class="image">
          <a class="avatar" href="#{path}">
            <img alt="#{name}" src="#{avatar_square}" height="100" width="100">
          </a>
        </div>
        <div class="title">
          <h1><a href="#{path}">#{name}</a></h1>
          <h2>
            #{likes}
            <span class="gray">Likes</span>
          </h2>
        </div>
        <div class="buttons">
          <a class="btn btn-large btn-edit" href="#{path}">
            <i class="icon-flag"></i>
            Manage Page
          </a>
        </div>
      </div>
    eos
  end

  # def preview_template
  #   @preview_template = ActionController::Base.new.send("render_to_string", { :partial => 'facebook_pages/preview.html.haml', :locals => { :facebook_page => self }})
  # end

  def path
    Rails.application.routes.url_helpers.facebook_page_path(self)
  end
end
