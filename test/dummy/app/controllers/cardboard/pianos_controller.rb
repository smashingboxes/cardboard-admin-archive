class Cardboard::PianosController < Cardboard::ResourceController

  def permitted_strong_parameters
    :all #or an array of parameters, example: [:name, :email]
  end
end