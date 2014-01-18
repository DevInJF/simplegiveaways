class EntriesDatatable < AjaxDatatablesRails

  def initialize(view, options = {})
    @model_name = Entry
    @giveaway = Giveaway.find(options[:giveaway_id])
    @columns = %w(entries.name entries.email entries.is_viral entries.total_shares entries.wall_post_count entries.request_count entries.convert_count entries.bonus_entries entries.created_at)
    @searchable_columns = %w(entries.name entries.email)
    super(view)
  end

private

    def data
      entries.map do |entry|
        attrs = [
          entry.name,
          entry.email,
          entry.new_fan?,
          entry.total_shares,
          entry.bonus_entries,
          entry.created_at.strftime('%b %d, %Y @ %l:%M %p')
        ]
        if entry.giveaway.canhaz_referral_tracking?
          attrs.push(entry.is_viral, entry.convert_count)
        end
        if entry.giveaway.canhaz_advanced_analytics?
          attrs.push(entry.wall_post_count, entry.request_count)
        end
        attrs
      end
    end

    def entries
      @entries ||= fetch_records
    end

    def get_raw_records
      @giveaway.entries
    end

    def get_raw_record_count
      search_records(get_raw_records).count
    end

    # ==== Insert 'presenter'-like methods below if necessary
end
