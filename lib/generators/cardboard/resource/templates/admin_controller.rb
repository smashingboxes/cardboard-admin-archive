class <%= controller_name.camelize %> < Cardboard::ResourceController
  # uses inherited_resources. For more info see https://github.com/josevalim/inherited_resources
  actions :all, :except => [:show]

  # If you are not using strong parameters comment the method below
  def permitted_strong_parameters
    :all #or an array of parameters, example: [:name, :email]
  end
end