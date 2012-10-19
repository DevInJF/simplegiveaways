class Leaf

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :app_data, :page, :active_resource, :visitor, :outbound_cookie

  # Needs to take some options to be gemified
  # Name of the model that holds Facebook pages
  # Name of the model that is the active resource for a Facebook page tab
  # Name of the pertinent url param for app data when app_data is not used

  def initialize(request)
    @request = request
    @oauth = Koala::Facebook::OAuth.new( FB_APP_ID, FB_APP_SECRET )
    @parsed_request ||= parsed_request( request.params[:signed_request] )
  end

  def app_data
    @app_data ||= @request.params[:app_data]
  end

  def page
    @page ||= OpenStruct.new( id: @parsed_request.page['id'] )
    # @page ||= FacebookPage.find_by_pid( @parsed_request.page['id'] )
  end

  def active_resource
    # @active_resource ||= @page.active_resource
  end

  def visitor
    attrs = visitor_is_app_user? ? visitor_authd_attrs : visitor_default_attrs
    @visitor ||= OpenStruct.new( attrs )
  end

  def outbound_cookie
    @outbound_cookie ||= { value: outbound_cookie_value, expires: 1.year.from_now }
  end

  def referral_source
    # notification
    # feed
    # reminders
    # search
    # appcenter_request
    # bookmark_apps
    # myapps
    # request
    # timeline
    # canvasbookmark
  end

  private

  def parsed_request(signed_request)
    OpenStruct.new(@oauth.parse_signed_request(signed_request))
  end

  def visitor_authd_attrs
    visitor_default_attrs.merge(
      id: @parsed_request.user_id,
      oauth_token: @parsed_request.oauth_token,
      token_issued: DateTime.strptime("#{@parsed_request.issued_at}", '%s'),
      token_expires: DateTime.strptime("#{@parsed_request.expires}", '%s'),
      admin: @parsed_request.page['admin'],
      liked: @parsed_request.page['liked']
    )
  end

  def visitor_default_attrs
    { country: @parsed_request.user['country'],
      locale: @parsed_request.user['locale'],
      age: "#{@parsed_request.user['age']['min']}",
      is_app_user?: visitor_is_app_user?,
      is_page_fan?: visitor_is_page_fan?,
      became_page_fan?: visitor_became_page_fan?,
      is_new?: visitor_is_new?,
      is_returning?: visitor_is_returning? }
  end

  def visitor_is_app_user?
    @parsed_request.user_id.present?
  end

  def visitor_is_page_fan?
    @parsed_request.page['liked']
  end

  def visitor_became_page_fan?
    visitor_is_page_fan? && inbound_cookie['is_page_fan'] == false
  end

  def visitor_is_new?
    inbound_cookie.nil?
  end

  def visitor_is_returning?
    inbound_cookie.present?
  end

  def outbound_cookie_value
    { is_page_fan: visitor_is_page_fan? }.to_json
  end

  def inbound_cookie
    @inbound_cookie ||= JSON.parse( cookie_jar.signed[cookie_key.to_sym] )
  end

  def cookie_jar
    @cookie_jar ||= @request.cookie_jar
  end

  def cookie_key
    "_leaf_#{FB_APP_ID}_#{page.id}"
  end
end