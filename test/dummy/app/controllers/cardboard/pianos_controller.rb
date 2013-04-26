class Cardboard::PianosController < Cardboard::AdminController
  inherit_resources
  defaults :route_prefix => 'admin'


  def self.icon
    # see http://fortawesome.github.io/Font-Awesome/ for more icon options
    "icon-file-alt"
  end
end