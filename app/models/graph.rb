class Graph

  attr_accessor :resource

  def initialize(resource)
    return unless @resource = resource
  end

  def page_likes
    return unless @resource.is_a? FacebookPage
    @resource.audits.map do |audit|
      format_audit(audit, audit.audited_changes["likes"])
    end.compact
  end

  private

  def format_audit(audit, audit_ary)
    if audit_ary.is_a? Array
      [ js_timestamp(audit.created_at), audit_ary.last ]
    else
      nil
    end
  end

  def js_timestamp(time)
    time.to_i * 1000
  end
end