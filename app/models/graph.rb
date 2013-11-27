class Graph

  def initialize(giveaway)
    return unless @giveaway = giveaway
  end

  def page_likes
    graphable_audits.map do |audit|
      if audit.is.has_key?(:analytics)
        format_audit(audit, audit.is[:analytics][:_page_likes])
      end
    end.compact
  end

  def net_likes
    graphable_audits.map do |audit|
      if audit.is.has_key?(:analytics)
        format_audit(audit, audit.is[:analytics][:_page_likes_while_active])
      end
    end.compact
  end

  def entries
    graphable_audits.map do |audit|
      if audit.is.has_key?(:analytics)
        format_audit(audit, audit.is[:analytics][:_entry_count])
      end
    end.compact
  end

  def views
    graphable_audits.map do |audit|
      if audit.is.has_key?(:analytics)
        format_audit(audit, audit.is[:analytics][:_views])
      end
    end.compact
  end

  private

  def graphable_audits
    @graphable_audits ||= @giveaway.audits.where("created_at >= ? AND created_at <= ?", @giveaway.start_date, @giveaway.end_date)
  rescue => e
    []
  end

  def format_audit(audit, audit_attr)
    val = audit_attr.nil? ? 0 : audit_attr
    [js_timestamp(audit.created_at), val]
  end

  def js_timestamp(time)
    time.to_i * 1000
  end
end
