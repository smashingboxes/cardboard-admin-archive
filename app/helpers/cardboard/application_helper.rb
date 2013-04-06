module Cardboard
  module ApplicationHelper
    # Convention: add cardboard_ to the name of any helper not returning html
    def cardboard_pages
      @cardboard_pages ||= Cardboard::Page.all
    end
    def cardboard_index
      @cardboard_index ||= Cardboard::Page.root
    end

    # Example: 
    #  link_to_page 123, class: "btn" do |page|
    #    "hello #{page.title}"
    #  end
    #   
    def link_to_page(id, html_options={}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      page = Cardboard::Page.where(id: id).first
      link_to(capture(page, &block), page.url, html_options)
    end

  end
end
