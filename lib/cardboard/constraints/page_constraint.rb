class PageConstraint
  def self.matches?(request)
    return false unless %w[html json js].include?(request.format.to_s.split("/")[1])
    return false unless page = Cardboard::Url.urlable_for(request.params[:id])
    page.class.name == "Cardboard::Page"
  end
end