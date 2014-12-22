module Cardboard
  module ApplicationHelper
  end

  module ActionView::Helpers::UrlHelper
    def link_to_with_new_tab(name = nil, options = nil, html_options = nil, &block)
      if options.is_a?(String)
        if request.fullpath =~ /cardboard\// && options !~ /cardboard\/|#{ Cardboard.user_class.name.underscore }\//
          html_options ||= {}
          html_options[:target] = "_blank"
        end
      end
      link_to_without_new_tab(name, options, html_options, &block)
    end
    alias_method_chain :link_to, :new_tab
  end
end
