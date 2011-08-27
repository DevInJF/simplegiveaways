module ApplicationHelper
  
  # http://goo.gl/Pax6C
  
  def title(window_title, options={})
    content_for(:title, window_title.to_s)
  end
  
  def h1(page_title, options={})
    content_for(:h1, page_title.to_s)    
  end

  # http://goo.gl/r0LCo

  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end
end