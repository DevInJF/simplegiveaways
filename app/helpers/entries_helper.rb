module EntriesHelper

  include ActionView::Helpers::UrlHelper

  def entry_name(entry)
    if entry.name.present?
      link_to entry.name, entry.fb_url, target: '_blank'
    else
      "&mdash;".html_safe
    end
  end
end
