class <%= controller_name.camelize %> < Cardboard::AdminController
  inherit_resources
  defaults :route_prefix => 'admin'


  def self.icon
    # see http://fortawesome.github.io/Font-Awesome/ for more icon options
    "icon-file-alt"
  end

  private

  # # Uncomment if you are using strong_parameters
  # def resource_params
  #   return [] if request.get?
  #   [ params.require(:<%= singular_table_name %>).permit! ]
  # end
end