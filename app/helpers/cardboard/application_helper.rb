module Cardboard
  module ApplicationHelper

    def inline_svg(path)
      File.open("app/assets/images/#{path}", "rb") do |file|
        raw file.read
      end
    end
    
  end
end
