# -*- encoding : utf-8 -*-
class FacebookPage < ActiveRecord::Base

  include ActionView::Helpers::UrlHelper

  has_many :giveaways
  has_and_belongs_to_many :users

  validates :pid, :uniqueness => true

  def self.retrieve_fb_meta(user, pages)
    pages = FacebookPage.select_pages(pages).compact.flatten
    page_count = (pages.size - 1)

    pages.each_with_index do |page_hash, index|

                  page = page_hash[:page]
               fb_meta = page_hash[:fb_meta][:data]
      fb_avatar_square = page_hash[:fb_meta][:avatar_square]
       fb_avatar_large = page_hash[:fb_meta][:avatar_large]

      @page = FacebookPage.find_or_create_by_pid(page["id"])

      previous_likes = @page.likes || fb_meta["likes"]

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

      jug_data = { :markup => @page.preview_template(previous_likes),
                   :is_last => "#{index == page_count}" }

      Juggernaut.publish("users#show", jug_data.to_json)

      unless user.facebook_pages.include? @page
        user.facebook_pages << @page
      end
    end
  end

  def self.select_pages(pages)
    pages = pages.reject do |page|
      page["category"] == "Application"
    end

    pages.collect do |page|
      page_hash = FacebookPage.eligible_page?(page)
      if page_hash[:eligible]
        { :page => page, :fb_meta => page_hash[:fb_meta] }
      end
    end
  end

  def self.eligible_page?(page)
    @graph = Koala::Facebook::API.new(page["access_token"])

    batch_data = @graph.batch do |batch_api|
      batch_api.get_object("me")
      batch_api.get_picture("me", :type => "square")
      batch_api.get_picture("me", :type => "large")
    end

    fb_meta          = batch_data[0]
    fb_avatar_square = batch_data[1]
    fb_avatar_large  = batch_data[2]

    { :eligible => (fb_meta["link"].include? "facebook.com"),
      :fb_meta => { :data => fb_meta,
                    :avatar_square => fb_avatar_square,
                    :avatar_large => fb_avatar_large }
    }
  end

  def preview_template(previous_likes)
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
            <span class="dynamo" data-lines="#{likes}">#{previous_likes}</span>
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
