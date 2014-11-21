class <%= controller_name.camelize %> < Cardboard::ResourceController
  before_action :set_<%= resource_name %>, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @<%= resource_name.pluralize %> = <%= resource_name.titleize %>.all
    respond_with(@<%= resource_name.pluralize %>)
  end

  def show
    respond_with(@<%= resource_name %>)
  end

  def new
    @<% resource_name %>= @<%= resource_name.titleize %>.new
    respond_with(@<%= resource_name %>)
  end

  def edit
  end

  def create
    @<% resource_name %>= @<%= resource_name.titleize %>.new(<%= resource_name %>_params)
    @<%= resource_name %>.save
    respond_with(@<%= resource_name %>)
  end

  def update
    @<%= resource_name %>.update(<%= resource_name %>_params)
    respond_with(@<%= resource_name %>)
  end

  def destroy
    @<%= resource_name %>.destroy
    respond_with(@<%= resource_name %>)
  end

  private
    def set_<%= resource_name %>
      @<%= resource_name %> = <%= resource_name.titleize %>.find(params[:id])
    end

    def <%= resource_name %>_params
      params[:<%= resource_name %>]
    end
end
