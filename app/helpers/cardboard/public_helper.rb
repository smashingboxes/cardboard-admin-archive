module Cardboard
  module PublicHelper

    # Example: 
    #  link_to_page 123, class: "btn" do |page|
    #    "hello #{page.title}"
    #  end
    #
    # link_to_page "home"
    #   
    def link_to_page(page_id, html_options={}, &block)
      
      page = Cardboard::Page.where(id: page_id).first if page_id.is_a? Integer
      page = Cardboard::Page.where(identifier: page_id).first if page_id.is_a? String
      
      if block_given?
        return nil if page.blank?
        title = capture(page, &block)
      else
        return link_to(page_id, page_path(id: page_id), html_options)
        title = page.title
      end
      link_to(title, page.url, html_options)
    end

    # Example 1:
    # = nested_pages Cardboard::Page.arrange do |page, subpages|
    #   .indent
    #     = link_to(page.title, page.url) if page.in_menu?
    #     = subpages
    # end
    # Example 2:
    # %ul
    #   = nested_pages do |page, subpages|
    #     %li
    #       = link_to page.title, edit_page_path(page)
    #       = content_tag(:ul, subpages) if subpages.present?
    def nested_pages(page = nil, &block)
      raise ArgumentError, "Missing block" unless block_given?
      inner_nested_pages(Cardboard::Page.arrange(page), &block).try(:html_safe)
    end

    private

    def inner_nested_pages(pages, &block)
      return unless pages
      pages.map do |page, sub_pages|
        capture(page, sub_pages.present? ? inner_nested_pages(sub_pages, &block) : nil, &block)
      end.join.html_safe
    end
  end
end