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

    # Example 1:
    # = nested_pages Cardboard::Page.arrange do |page, subpages|
    #   .indent
    #     = link_to(page.title, edit_page_path(page))
    #     = subpages
    # end
    # Example 2:
    # %ul
    #   = nested_pages do |page, subpages|
    #     %li
    #       = link_to page.title, edit_page_path(page)
    #       = content_tag(:ul, subpages) if subpage.present?
    def nested_pages(pages = Cardboard::Page.arrange, &block)
      raise ArgumentError, "Missing block" unless block_given?
      pages.map do |page, sub_pages|
        capture(page, sub_pages.present? ? nested_pages(sub_pages, &block) : nil, &block)
      end.join.html_safe
    end

  end
end