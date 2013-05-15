class Cardboard::AdminController <  InheritedResources::Base
  defaults :route_prefix => 'cardboard'

  before_filter :authenticate_admin_user!
  before_filter :for_gon
  
  layout "layouts/cardboard/application"

  def collection
    @q ||= end_of_association_chain.search(params[:q])
    get_collection_ivar || begin
      set_collection_ivar((@q.respond_to?(:scoped) ? @q.scoped.result(:distinct => true) : @q.result(:distinct => true)).page(params[:page]))
    end
  end

  private

  def for_gon
    gon.rich_text_links_modal = render_to_string(:partial => "cardboard/rich_editor/links_modal", :layout => false)
  end

  def permitted_strong_parameters
    :all
  end

  # bypass strong_parameters (unless overwritten in controller)
  def resource_params
    return [] if request.get?
    return super if params && params.class.to_s != "ActionController::Parameters"
    if permitted_strong_parameters == :all
      [ params.require(resource_instance_name.to_sym).permit! ]
    else
      [ params.require(resource_instance_name.to_sym).permit(*permitted_strong_parameters)]
    end
  end

end

