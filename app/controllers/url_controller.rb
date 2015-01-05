class UrlController < ApplicationController
  before_filter :apply_cardboard
  include Cardboard::ContentForInControllers

private

  def apply_cardboard
    raise ActionController::RoutingError.new('Cardboard Page Not Found. You may want to skip the filter "apply_cardboard"') unless current_page

    if current_page.using_slug_backup?
      redirect_to current_page.url, status: :moved_permanently
    else
      render_seo
    end
  end

  def render_seo
    title = (current_page.meta_tags.delete("title") || current_page.meta_tags.delete(:title))
    seo = "" 
    seo += "<title>#{Cardboard::Setting.company_name}#{" | " + title unless title.blank?}</title>"
    seo += current_page.meta_tags.map{|key, value| "<meta name='#{key}' content='#{value}' />"}.join
    content_for :seo, seo.html_safe
  end

  def current_page
    return @cardboard_page unless @cardboard_page.nil?

    @cardboard_page = if request.path == "/"
      Cardboard::Page.root
    else
      Cardboard::Url.urlable_for(request.path) 
    end
  end
end
