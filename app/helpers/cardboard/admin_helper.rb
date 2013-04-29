module Cardboard
  module AdminHelper

    def l(val, options = {})
      return nil if val.blank?
      val = val.to_date if val.is_a? String
      super(val, options)
    end

    ActionView::Helpers::FormBuilder.class_eval do
      def date_field(conf,*opts)
        options = opts || []
        options = opts.first || {}
        options[:class] = "#{options[:class]} datepicker" 
        text_field(conf,*options)
      end
    end



  end
end