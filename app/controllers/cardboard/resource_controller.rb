require_dependency "cardboard/application_controller"

class Cardboard::ResourceController <  Cardboard::ApplicationController
  before_filter :check_ability

  def self.singular?
    name = controller_name
    name == name.singularize and name != name.pluralize
  end

  def collection
    @q ||= end_of_association_chain.search(params[:q])

    @q.sorts = self.class.default_order if @q.sorts.empty?
    get_collection_ivar || begin
      set_collection_ivar((@q.respond_to?(:scoped) ? @q.scoped.result : @q.result).page(params[:page]))
    end
  end

private

  def self.default_order(val = nil)
    @default_order ||= 'updated_at desc'
    return @default_order if val.nil?
    @default_order = val.to_s
  end

  def self.menu(hash = nil)
    @menu = {priority: 999, label: self.controller_name.to_s.titleize} if @menu.nil? #menu might be false, so no ||=
    return @menu if hash.nil?
    @menu = hash.is_a?(Hash) ? @menu.merge(hash) : hash
  end

  def check_ability
    unless cardboard_user_can_manage?(controller_name)
      render :text => "You are not authorized to access this resource.", :status => :unauthorized
    end
  end

  def permitted_strong_parameters
    :all   # bypass strong_parameters (unless overwritten in controller)
  end

end
