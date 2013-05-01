module Cardboard
  module AdminHelper

    def l(val, options = {})
      return nil if val.blank?
      val = val.to_date if val.is_a? String
      super(val, options)
    end

    ActionView::Helpers::FormBuilder.class_eval do
      def date_field(conf,opts = {})
        options = opts.dup
        options[:class] = "#{options[:class]} datepicker" 
        text_field(conf, options)
      end
    end

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

    def cardboard_filters(array, f)
      html = ""
      array.each do |c|
        case c[1].to_sym
        when :string
          html += f.label "#{c[0]}_cont"
          html += f.text_field "#{c[0]}_cont"
        when :integer
          html += f.label "#{c[0]}_lt"
          html += f.text_field "#{c[0]}_lt"
          html += f.label "#{c[0]}_gteq"
          html += f.text_field "#{c[0]}_gteq"
        when :datetime
          html += f.label "#{c[0]}_lteq"
          html += f.text_field "#{c[0]}_lt", class: "datepicker" , value: params["q"] ? l(params["q"]["#{c[0]}_lt"]) : nil
          html += f.label "#{c[0]}_gteq"
          html += f.date_field "#{c[0]}_gteq", value: params["q"] ? l(params["q"]["#{c[0]}_gteq"]) : nil
        end
      end
      html += "<br>"
      html.html_safe
    end
  end
end