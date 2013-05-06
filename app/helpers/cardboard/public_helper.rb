module Cardboard
  module PublicHelper
    # Convention: add cardboard_ to the name of any helper not returning html
    def cardboard_pages
      @cardboard_pages ||= Cardboard::Page.arrange
    end
    def cardboard_index
      @cardboard_index ||= Cardboard::Page.root
    end

    # Example: 
    #  link_to_page 123, class: "btn" do |page|
    #    "hello #{page.title}"
    #  end
    #   
    def link_to_page(page, html_options={}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      page = Cardboard::Page.where(id: page).first 
      page = Cardboard::Page.where(identifier: page).first 
      return nil if page.blank?
      link_to(capture(page, &block), page.url, html_options)
    end

    # def nested_nav(pages)
    #   pages.map do |page, sub_pages|
    #     if page.in_menu?
    #       html =  content_tag(:div, link_to(page.title, page.url) , :class => "indent")
    #       html += content_tag(:div, nested_nav(sub_pages), :class => "indent") unless sub_pages.blank? 
    #       html
    #     end
    #   end.join.html_safe
    # end

    def meta_and_title(page)
      return nil unless page
      seo = page.meta_seo.dup
      html = ""
      html += "<title>#{seo.delete(:title)}</title>" if seo[:title]
      seo.each do |key, value|
        html += "<meta name='#{key}' content='#{value}' />\n"
      end
      html.html_safe
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
      inner_nested_pages(Cardboard::Page.arrange(page), &block).html_safe
    end

    private

    def inner_nested_pages(pages, &block)
      pages.map do |page, sub_pages|
        capture(page, sub_pages.present? ? inner_nested_pages(sub_pages, &block) : nil, &block)
      end.join.html_safe
    end
  end
end