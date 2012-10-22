class Blotter

  cattr_accessor :blotter_model; self.blotter_model = nil
  cattr_accessor :blotter_art_method; self.blotter_art_method = nil

  def initialize(request)
    @request = request
    raise ArgumentError if bad_request?
  end

  def self.register_blotter_model(blotter_model)
    self.blotter_model = blotter_model
  end

  def self.register_blotter_art_method(blotter_art_method)
    self.blotter_art_method = blotter_art_method
  end

  def page
    matched_page_resource(payload['page']['id'])
  end

  def visitor
    visitor = payload['user']
    visitor.merge!("uid" => payload['user_id']) if payload.has_key? 'user_id'
  end

  def referral_type
    @request.params['fb_source']
  end

  def payload
    @parsed_request ||= parsed_request
  end

  private

  def parsed_request
    @oauth ||= Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    @oauth.parse_signed_request(@request.params['signed_request'])
  end

  def bad_request?
    true unless expected_object? and expected_source? and expected_params?
  end

  def expected_object?
    @request.respond_to? 'params'
  end

  def expected_source?
    @request.env && @request.env['HTTP_ORIGIN'].match(/facebook\.com$/)
  end

  def expected_params?
    @request.params['signed_request'].length > 0
  end

  def matched_page_resource(pid)
    dirty_results = likely_pid_columns.map do |column_name|
      begin
        break if blotter_model.class_eval("find_by_#{column_name}(#{pid})")
      rescue NoMethodError
        next
      end
    end
    dirty_results.compact.pop
  end

  def likely_pid_columns
    columns = blotter_model.columns.select { |column| eligible_column? column }
    columns.map(&:name)
  end

  def eligible_column?(column)
    [:string, :integer, :text].include? column.type and column.name =~
        common_pid_column_names
  end

  def common_pid_column_names
    /page_id|pid|facebook_id|facebook_page_id|facebook_pid|fb_pid|fb_page_id|fb_id|fbid|fbpid|fid|fpid/
  end
end