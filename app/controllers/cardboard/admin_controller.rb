require_dependency "cardboard/application_controller"

class Cardboard::AdminController <  Cardboard::ApplicationController
  inherit_resources

  defaults :route_prefix => 'cardboard'

  before_filter :check_ability

  def collection
    @q ||= end_of_association_chain.search(params[:q])
    get_collection_ivar || begin
      set_collection_ivar((@q.respond_to?(:scoped) ? @q.scoped.result(:distinct => true) : @q.result(:distinct => true)).page(params[:page]))
    end
  end

  private

  def check_ability
    unless self.send(Cardboard.application.current_admin_user_method).can_manage_cardboard_resource?(resource_instance_name)
      render :text => "You are not authorized to access this resource.", :status => :unauthorized 
    end
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

