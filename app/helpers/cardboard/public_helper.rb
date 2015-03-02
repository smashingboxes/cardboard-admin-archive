module Cardboard
  module PublicHelper

    def dragonfly_image_tag(image, options = {})
      return nil unless image
      size = options.delete(:size) || '125x125>'
      image_tag image.thumb(size).url, options
    end

    def link_to_file(text, file, options = {})
      return link_to(text, nil, options) unless file && file.url

      html = ""
      if [:doc, :docx, :xls, :xlsx, :pdf, :zip, :txt].include?(file.format)
        html += image_tag("cardboard/icons/#{file.format}.png")
      end
      html += link_to(text, file.url, options)
      html.html_safe
    end

    # Example: 
    #  link_to_page 123, class: "btn" do |page|
    #    "hello #{page.title}"
    #  end
    #
    # link_to_page "home"
    #   
    def link_to_page(page_id, html_options={}, &block)  
      page = if page_id.is_a?(Integer)
        Cardboard::Page.where(id: page_id).first 
      else #if page_id.is_a? String
        Cardboard::Page.where(identifier: page_id).first 
      end
      return nil if page.blank?

      title = if block_given?
        capture(page, &block)
      else
        page.title
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

    def inline_svg(path)
      File.open("#{Rails.root}/app/assets/images/#{path}", "rb") do |file|
        raw file.read
      end
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
