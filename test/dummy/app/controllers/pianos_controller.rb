class PianosController < ApplicationController
  # GET /pianos
  # GET /pianos.json
  def index
    @pianos = Piano.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pianos }
    end
  end

  # GET /pianos/1
  # GET /pianos/1.json
  def show
    @piano = Piano.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @piano }
    end
  end

  # GET /pianos/new
  # GET /pianos/new.json
  def new
    @piano = Piano.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @piano }
    end
  end

  # GET /pianos/1/edit
  def edit
    @piano = Piano.find(params[:id])
  end

  # POST /pianos
  # POST /pianos.json
  def create
    @piano = Piano.new(params[:piano])

    respond_to do |format|
      if @piano.save
        format.html { redirect_to @piano, notice: 'Piano was successfully created.' }
        format.json { render json: @piano, status: :created, location: @piano }
      else
        format.html { render action: "new" }
        format.json { render json: @piano.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pianos/1
  # PUT /pianos/1.json
  def update
    @piano = Piano.find(params[:id])

    respond_to do |format|
      if @piano.update_attributes(params[:piano])
        format.html { redirect_to @piano, notice: 'Piano was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @piano.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pianos/1
  # DELETE /pianos/1.json
  def destroy
    @piano = Piano.find(params[:id])
    @piano.destroy

    respond_to do |format|
      format.html { redirect_to pianos_url }
      format.json { head :no_content }
    end
  end
end
