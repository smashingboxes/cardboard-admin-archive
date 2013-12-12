module Cardboard
  module ResourceHelper

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

    def cardboard_filters(klass, main_element, options={})
      raise "First argument needs to be a class" unless klass.is_a? Class

      options[:new_button] = Hash.new if options[:new_button].nil? #careful for false

      if main_element
        # valid main elements:
        # false (don't show the search form)
        # :column_name
        # "column_name_cont"
        main_element = main_element.to_s

        case type = klass.columns_hash[main_element].try(:type)
        when :string, :text
          main_element = "#{main_element}_cont"
        when :integer, :decimal, :float
          main_element = "#{main_element}_eq"
        when :date, :datetime, :timestamp, :time, :binary, :boolean, :references
          raise "Main search element cannot be of type #{type}. Use a custom ransack form."
        else
          main_element = "#{main_element}_cont" unless %w[cont eq lt gt gteq lteq matches in cont_any start end].include?(main_element.split("_").last)
        end
      end
      
      render "cardboard/resources/search_helper", klass: klass.to_s.demodulize.underscore, options: options, main_element: main_element #,elements: elements
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
