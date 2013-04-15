module Cardboard
  class ApplicationController < ActionController::Base

    before_filter :for_gon
    
    private

    def for_gon
      gon.rich_text_links_modal = render_to_string(:partial => "cardboard/rich_editor/links_modal", :layout => false)
    end

    # nested_pages_json(Cardboard::Page.arrange)
    # def nested_pages_json(pages)
    #   pages.map do |page, sub_pages|
    #     json =  {title: page.title, url: page.url}.to_json 
    #     json += nested_pages_json(sub_pages) unless sub_pages.blank? 
    #     json
    #   end.join
    # end

  end
end
