class Giveaway < ActiveRecord::Base
  is_impressionable

  belongs_to :facebook_page
  has_many :entries

  validates :title, :presence => true, :uniqueness => { :scope => :facebook_page_id }
  validates :description, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :prize, :presence => true
  validates_attachment_presence :image
  validates_attachment_presence :feed_image
  validates :terms, :presence => true

  validate :end_in_future
 
  # Paperclip 
  has_attached_file :image,
    :styles => {
      :thumb  => "150x150>",
      :medium => "300x300>" },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"
    
  has_attached_file :feed_image,
    :styles => {
      :thumb  => "45x45>",
      :feed => "90x90>" },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"

  def is_live?
    now = Time.now
    start_date < now && end_date > now ? true : false
  end
  
  def is_installed?
    @graph = Koala::Facebook::API.new(facebook_page.token)
    @graph.fql_query("SELECT has_added_app FROM page WHERE page_id=#{facebook_page.pid}")[0]["has_added_app"]
  end

  def count_conversion(ref)
    ref = entries.find(ref)
    ref.convert_count += 1
    ref.save
  end
  handle_asynchronously :count_conversion

  def total_shares
    all_shares = entries.collect(&:share_count)
    all_shares.inject(:+) || 0
  end

  def total_requests
    all_requests = entries.collect(&:request_count)
    all_requests.inject(:+) || 0
  end

  def total_conversions
    all_conversions = entries.collect(&:convert_count)
    all_conversions.inject(:+) || 0
  end

  def conversion_rate
    "#{((total_conversions.to_f / (total_shares.to_f + total_requests.to_f)) * 100).round(2)}%"
  rescue StandardError
    0
  end

  class << self

    def render(params, *apprequest)
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      graph = Koala::Facebook::API.new(FB_APP_TOKEN)

      signed_request = oauth.parse_signed_request(params[:signed_request])

      if apprequest.present?
        request = graph.get_object(params[:request_ids])

        giveaway = Giveaway.find_by_id(JSON.parse(request["data"])["giveaway_id"])

        {
          "app_data" => request["data"],
          "has_liked" => false,
          "request_ids" => params["request_ids"],
          "current_page" => giveaway.facebook_page,
          "giveaway" => giveaway
        }
      else
        current_page = FacebookPage.select("id, url, name").find_by_pid(signed_request["page"]["id"])

        {
          "app_data" => signed_request["app_data"],
          "has_liked" => signed_request["page"]["liked"],
          "current_page" => current_page,
          "giveaway" => current_page.giveaways.detect(&:is_live?)
        }
      end
    end

    def delete_app_request(params)
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      graph = Koala::Facebook::API.new(FB_APP_TOKEN)
      signed_request = oauth.parse_signed_request(params[:signed_request])
      request_ids = params[:request_ids]

      request_ids.split(",").each do |request|
        graph.delete_object "#{request}_#{signed_request["user_id"]}"
      end
    end
  end

  private

  def end_in_future
    if end_date < start_date
      errors[:base] << "End date must be in the future"
    end
  end
end
