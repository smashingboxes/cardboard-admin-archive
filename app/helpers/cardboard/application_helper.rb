module Cardboard
  module ApplicationHelper


    # .item
    #     = link_to dashboard_path, id:"nav_dashboard_link" do
    #       i.icon-dashboard
    #       span Dashboard
    def main_sidebar_nav_link(text, link, options={})
      icon = options.delete(:icon)
      out = content_tag(:div, class:"item") do
        link_to("<i class='#{icon}'></i><span>#{text}</span>".html_safe, link, options)
      end
      out.html_safe
    end

  end
end