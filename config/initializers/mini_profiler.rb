if %w(development test).include? Rails.env
  Rack::MiniProfiler.profile_method(ActiveRecord::Querying, "all")
end