class Cardboard::PianosController < Cardboard::ResourceController
  before_action :set_piano, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @q = Piano.search(params[:q])
    @pianos = @q.result(distinct: true).page(params[:page])
    respond_with(@pianos)
  end

  def new
    @piano = Piano.new
    respond_with(@piano)
  end

  def edit
  end

  def create
    @piano = Piano.new(piano_params)
    @piano.save
    respond_with(@piano, location: cardboard_pianos_path)
  end

  def update
    @piano.update(piano_params)
    respond_with(@piano, location: cardboard_pianos_path)
  end

  def destroy
    @piano.destroy
    respond_with(@piano)
  end

  private
    def set_piano
      @piano = Piano.find(params[:id])
    end

    def piano_params
      params.require(:piano).permit!
    end
end
