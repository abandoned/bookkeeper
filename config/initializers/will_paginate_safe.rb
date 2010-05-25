# Patched WillPaginate 2.3.12 to work with Rails 2.3.7+.

WillPaginate::ViewHelpers.pagination_options.each_pair do |key, value|
  if value.class == String
    WillPaginate::ViewHelpers.pagination_options[key] = value.html_safe
  end
end

class WillPaginate::LinkRenderer
  def to_html
    links = @options[:page_links] ? windowed_links : []
    # previous/next buttons
    links.unshift page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
    links.push    page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
  
    html = links.join(@options[:separator]).html_safe
    @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
  end
end
