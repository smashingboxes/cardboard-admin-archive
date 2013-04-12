module Cardboard
  module ApplicationHelper
    # def method_missing(method, *args, &block)
    #   if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
    #     main_app.send(method, *args)
    #   else
    #     super
    #   end
    # end
  end
end

# ActionController::Base.send(:helper, Cardboard::ApplicationHelper)