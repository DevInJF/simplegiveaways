module UiHelper

  def callout(options = {}, &block)
    type = options[:type] || 'info'
    haml_tag :div, class: "bs-callout bs-callout-#{type}" do
      haml_tag :h4, options[:title]
      if block
        block.call
      else
        haml_tag :p, options[:content]
      end
    end
  end
end
