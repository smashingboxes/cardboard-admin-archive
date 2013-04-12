module Cardboard
  module AdminHelper

  def admin_nested_nav(pages)
    pages.map do |page, sub_pages|
      html =  content_tag(:div, link_to(page.title, edit_cardboard_page_path(page)) , :class => "indent")
      html += content_tag(:div, admin_nested_nav(sub_pages), :class => "indent") unless sub_pages.blank? 
      html
    end.join.html_safe
  end

  end
end