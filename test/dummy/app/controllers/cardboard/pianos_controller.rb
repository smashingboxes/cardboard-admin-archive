class Cardboard::PianosController < Cardboard::ResourceController

  def permitted_strong_parameters
    :all #or an array of parameters, example: [:name, :email]
  end

  def index
    @pianos = Piano.all
  end

  def show
    @piano = Piano.find(params[:id])
  end

  def new
    @piano = Piano.new
  end

  def create
    @piano = Piano.new(piano_params)
    if @piano.save
      redirect_to cardboard_pianos_path, notice: "Successfully created piano"
    else
      render :new, alert: "Could not create piano"
    end
  end

  def edit
    @piano = Piano.find(params[:id])
  end

  def update
    @piano = Piano.find(params[:id])
    if @piano.update_attributes(piano_params)
      redirect_to cardboard_piano_path(@piano), notice: "Successfully edited piano"
    else
      render :edit, alert: "Could not edit piano"
    end
  end

  def destroy
    @piano = Piano.find(params[:id])
    @piano.destroy
    redirect_to cardboard_pianos_path, notice: "Successfully deleted piano"
  end

  private

  def piano_params
    params.require(:piano).permit(:name, :image, :rich_text)
  end
end
