class EntriesDatatable < AjaxDatatablesRails

  include PublicUtils

  def initialize(view, options = {})
    @model_name = Entry
    @giveaway = Giveaway.find(view.params[:giveaway_id])
    @columns = %w(entries.name entries.email entries.is_viral entries.wall_post_count entries.request_count entries.convert_count entries.bonus_entries entries.created_at)
    @searchable_columns = %w(entries.name entries.email)
    @db_columns = db_columns
    @display_columns = display_columns
    @sort_order = set_sort_order(view.params[:sSortDir_0])
    @sort_column = set_sort_column(view.params[:iSortCol_0])
    super(view)
  end

  private

  def data
    entries.map do |entry|
      @display_columns.map { |attr| entry.send(attr) }
    end
  end

  def entries
    @entries ||= fetch_records
  end

  def get_raw_records
    if @sort_column == :new_fan?
      @giveaway.entries.includes(:likes).order("likes.entry_id #{@sort_order}")
    elsif @sort_column == :total_shares
      @giveaway.entries.order("wall_post_count + request_count #{@sort_order}")
    else
      @giveaway.entries.order("#{@sort_column.to_s} #{@sort_order}")
    end
  end

  def get_raw_record_count
    search_records(get_raw_records).count
  end

  def display_columns
    attrs = [:name, :email]
    attrs.push(:is_viral) if @giveaway.canhaz_referral_tracking?
    attrs.push(:new_fan?)
    attrs.push(:total_shares)
    if @giveaway.canhaz_advanced_analytics?
      attrs.push(:wall_post_count, :request_count)
    end
    attrs.push(:convert_count) if @giveaway.canhaz_referral_tracking?
    attrs.push(:bonus_entries)
    attrs.push(:friendly_created_at)
    attrs
  end

  def db_columns
    attrs = [:name, :email]
    attrs.push(:is_viral) if @giveaway.canhaz_referral_tracking?
    attrs.push(:new_fan?)
    attrs.push(:total_shares)
    if @giveaway.canhaz_advanced_analytics?
      attrs.push(:wall_post_count, :request_count)
    end
    attrs.push(:convert_count) if @giveaway.canhaz_referral_tracking?
    attrs.push(:bonus_entries)
    attrs.push(:created_at)
    attrs
  end

  def set_sort_order(sort_order_param = nil)
    sort_order_param ? sort_order_param.upcase : "DESC"
  end

  def set_sort_column(sort_column_param = nil)
    if sort_column_param
      @db_columns[sort_column_param.to_i] rescue nil
    else
      :created_at
    end
  end
end
