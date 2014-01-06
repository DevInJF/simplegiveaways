require 'dotiw'

module GiveawaysHelper

  include PublicUtils

  include ActionView::Helpers::DateHelper

  def time_from_now(time)
    distance_of_time_in_words(Time.now, time, false, only: %w(days hours), accumulate_on: :days)
  end

  def giveaway_header_class(giveaway)
    case giveaway.status
      when 'Active'
        'bg-primary'
      when 'Pending'
        'bg-dark'
      when 'Completed'
        'bg-danger'
    end
  end

  def status_label(giveaway)
    case giveaway.status
      when 'Active'
        active_status_label(giveaway)
      when 'Pending'
        pending_status_label(giveaway)
      when 'Completed'
        completed_status_label(giveaway)
    end
  end

  def active_status_label(giveaway)
    label = <<-eos
      <div class="ui ribbon label teal">
        <strong>Active</strong><br />
        Started on #{datetime_mdy(giveaway.start_date)}<br />
        Ends on #{datetime_mdy(giveaway.end_date)}
      </div>
    eos
    label.html_safe
  end

  def pending_status_label(giveaway)
    label = <<-eos
      <div class="ui ribbon label">
        <strong>Pending</strong><br />
    eos
    if giveaway.start_date
      label += <<-eos
        Starts on #{datetime_mdy(giveaway.start_date)}
      eos
    end
    if giveaway.end_date
      label += <<-eos
        <br />
        Ends on #{datetime_mdy(giveaway.end_date)}
      eos
    end
    label += "</div>"
    label.html_safe
  end

  def completed_status_label(giveaway)
    label = <<-eos
      <div class="ui ribbon label red">
        <strong>Completed</strong><br />
        Started on #{datetime_mdy(giveaway.start_date)}<br />
        Ended on #{datetime_mdy(giveaway.end_date)}
      </div>
    eos
    label.html_safe
  end

  def boolean_label(boolean)
    if to_bool(boolean)
      '<span class=\'label bg-primary\'>TRUE</span>'.html_safe
    else
      '<span class=\'label bg-danger\'>FALSE</span>'.html_safe
    end
  end

  def start_date_label(giveaway, relative = false)
    return "No Start Date" unless giveaway.start_date

    start_date = relative ? time_from_now(giveaway.start_date) : giveaway.start_date

    return start_date if giveaway.active? || giveaway.completed?
    if giveaway.cannot_schedule?
      "<span class='giveaway-start-date-warning popup-trigger' data-title='Inactive Start Date' data-content='A Pro subscription is required in order to schedule a giveaway.<br /><br /><a class=\"ui mini teal button\" href=\"#{facebook_page_subscription_plans_path(giveaway.facebook_page)}\">Choose a Plan</a>' data-on='click'><i class='warning icon'></i><s>#{start_date}</s></span>".html_safe
    elsif giveaway.has_scheduling_conflict?
      "<span class=\"giveaway-start-date-warning popup-trigger\" data-title=\"Inactive Start Date\" data-content=\"This giveaway has scheduling conflicts with the following giveaways:<br /><br />#{conflicts(giveaway)}<br /><br />Please update your giveaway schedules in order to activate this start date.<br /><br /><a class='ui mini teal button' href='#{edit_facebook_page_giveaway_path(giveaway.facebook_page, giveaway)}'>Edit Giveaway</a>\" data-on='click'><i class='warning icon'></i><s>#{start_date}</s></span>".html_safe
    else
      start_date
    end
  end

  def end_date_label(giveaway, relative = false)
    return "No End Date" unless giveaway.end_date

    end_date = relative ? time_from_now(giveaway.end_date) : giveaway.end_date

    return end_date if giveaway.completed?
    if giveaway.cannot_schedule?
      "<span class='giveaway-end-date-warning popup-trigger' data-title='Inactive End Date' data-content='A Pro subscription is required in order to schedule a giveaway.<br /><br /><a class=\"ui mini teal button\" href=\"#{facebook_page_subscription_plans_path(giveaway.facebook_page)}\">Choose a Plan</a>' data-on='click'><i class='warning icon'></i><s>#{end_date}</s></span>".html_safe
    elsif giveaway.has_scheduling_conflict?
      "<span class=\"giveaway-end-date-warning popup-trigger\" data-title=\"Inactive End Date\" data-content=\"This giveaway has scheduling conflicts with the following giveaways:<br /><br />#{conflicts(giveaway)}<br /><br />Please update your giveaway schedules in order to activate this end date.<br /><br /><a class='ui mini teal button' href='#{edit_facebook_page_giveaway_path(giveaway.facebook_page, giveaway)}'>Edit Giveaway</a>\" data-on='click'><i class='warning icon'></i><s>#{end_date}</s></span>".html_safe
    else
      end_date
    end
  end

  def conflicts(giveaway)
    giveaway.all_conflicts.map do |g|
      "<strong><a href='#{facebook_page_giveaway_path(g.facebook_page, g)}'>#{g.title}</a></strong>"
    end.join('<br />')
  end
end
