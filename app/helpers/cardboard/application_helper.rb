module Cardboard
  module ApplicationHelper
    def markdown(text, options={})
      options.reverse_merge!(
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        disabled_indented_code_blocks: true
      )
      renderer = Redcarpet::Render::HTML.new
      redcarpet = Redcarpet::Markdown.new(renderer, options)
      redcarpet.render(text).html_safe
    end
  end
end