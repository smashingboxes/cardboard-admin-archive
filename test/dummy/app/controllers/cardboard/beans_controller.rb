class Cardboard::BeansController < Cardboard::AdminController

  def self.icon
    # see http://fortawesome.github.io/Font-Awesome/ for more icon options
    "icon-coffee"
  end

  # def permitted_strong_parameters
  #   :all #or an array of parameters, example: [:name, :email]
  # end
end