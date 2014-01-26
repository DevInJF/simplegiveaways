class Graph

  private

  def format_audit(audit, audit_attr)
    val = audit_attr.nil? ? 0 : audit_attr
    [js_timestamp(audit.created_at), val]
  end

  def js_timestamp(time)
    time.to_i * 1000
  end
end
