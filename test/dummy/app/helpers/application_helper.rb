module ApplicationHelper
    def nested_nav(pages)
      pages.map do |page, sub_pages|
        html =  content_tag(:div, link_to(page.title, page.url) , :class => "indent")
        html += content_tag(:div, nested_nav(sub_pages), :class => "indent") unless sub_pages.blank? 
        html
      end.join.html_safe
    end
end
