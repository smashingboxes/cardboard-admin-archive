class <%= controller_name.camelize %> < Cardboard::ResourceController
  before_action :set_<%= singular_table_name %>, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @q = <%= resource_name.titleize %>.search(params[:q])
    @<%= plural_table_name %> = @q.result(distinct: true).page(params[:page])
    respond_with(@<%= plural_table_name %>)
  end

  def new
    @<%= singular_table_name %> = <%= resource_name.titleize %>.new
    respond_with(@<%= singular_table_name %>)
  end

  def edit
  end

  def create
    @<%= singular_table_name %> = <%= resource_name.titleize %>.new(<%= singular_table_name %>_params)
    @<%= singular_table_name %>.save
    respond_with(@<%= singular_table_name %>, location: cardboard_<%= plural_table_name %>_path)
  end

  def update
    @<%= singular_table_name %>.update(<%= singular_table_name %>_params)
    respond_with(@<%= singular_table_name %>, location: cardboard_<%= plural_table_name %>_path)
  end

  def destroy
    @<%= singular_table_name %>.destroy
    respond_with(@<%= singular_table_name %>)
  end

  private
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= resource_name.titleize %>.find(params[:id])
    end

    def <%= singular_table_name %>_params
      params.require(:<%= singular_table_name %>).permit!
    end
end
