class PianosController < ApplicationController
  before_action :set_piano, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @pianos = Piano.all
    respond_with(@pianos)
  end

  def show
    respond_with(@piano)
  end

  def new
    @piano = Piano.new
    respond_with(@piano)
  end

  def edit
  end

  def create
    @piano = Piano.new(piano_params)
    flash[:notice] = 'Piano was successfully created.' if @piano.save
    respond_with(@piano)
  end

  def update
    flash[:notice] = 'Piano was successfully updated.' if @piano.update(piano_params)
    respond_with(@piano)
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
      params.require(:piano).permit(:name)
    end
end
