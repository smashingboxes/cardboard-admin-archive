module Cardboard
  module AdminHelper

    def l(val, options = {})
      return nil if val.blank?
      val = val.to_date if val.is_a? String
      super(val, options)
    end

    # ActionView::Helpers::FormBuilder.class_eval do
    #   def date_field(conf,opts = {})
    #     options = opts.dup
    #     options[:class] = "#{options[:class]} datepicker" 
    #     text_field(conf, options)
    #   end
    # end

    # .item
    #     = link_to dashboard_path, id:"nav_dashboard_link" do
    #       i.icon-dashboard
    #       span Dashboard
    def main_sidebar_nav_link(text, link, options={})
      options[:class] = "#{options[:class]} active" if request.path["#{link}/"] || request.path == link
      out = content_tag(:div, class:"item") do
        link_to("<span>#{text}</span>".html_safe, link, options)
      end
      out.html_safe
    end

  #    "q"=>
  # {"id_lt"=>"1",
  #  "id_gteq"=>"1",
  #  "color_cont"=>"1",
  #  "flavor_cont"=>"",
  #  "size_lt"=>"",
  #  "size_gteq"=>"",
  #  "created_at_lt"=>"",
  #  "created_at_gteq"=>"",
  #  "updated_at_lt"=>"",
  #  "updated_at_gteq"=>""},

    def cardboard_filters(model, main_element, options={})
      raise "First argument needs to be a class" unless model.is_a? Class

      elements =  model.columns.inject([]) do |a, column|
        name = column.name.to_sym
        type = column.type.to_sym
        a << [name, type] if (options[:fields].blank? || options[:fields].include?(name)) #&& name != main_element.to_sym
        a
      end

      elements |= options[:associated_fields] if options[:associated_fields].present?

      render "cardboard/resources/search_helper", model: model.to_s.demodulize.underscore, elements: elements, options: options, main_element: main_element
    end


    def ransack_options 
      { 
        string: [["Contains","cont"],["Does not contain","not_cont"], ["Starts with","start"], ["Ends with","end"]], 
        datetime: [["On","eq"],["Before","lt"],["After","gt"]],
        integer: [["Greater than","gt"],["Equals","eq"],["Less than","lt"]],
        boolean: [["is False","blank"],["is True","true"]]
      }
    end

  end
end