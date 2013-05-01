class IcescreamsController < ApplicationController
  # GET /icescreams
  # GET /icescreams.json
  def index
    @icescreams = Icescream.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @icescreams }
    end
  end

  # GET /icescreams/1
  # GET /icescreams/1.json
  def show
    @icescream = Icescream.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @icescream }
    end
  end

  # GET /icescreams/new
  # GET /icescreams/new.json
  def new
    @icescream = Icescream.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @icescream }
    end
  end

  # GET /icescreams/1/edit
  def edit
    @icescream = Icescream.find(params[:id])
  end

  # POST /icescreams
  # POST /icescreams.json
  def create
    @icescream = Icescream.new(icescream_params)

    respond_to do |format|
      if @icescream.save
        format.html { redirect_to @icescream, notice: 'Icescream was successfully created.' }
        format.json { render json: @icescream, status: :created, location: @icescream }
      else
        format.html { render action: "new" }
        format.json { render json: @icescream.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /icescreams/1
  # PATCH/PUT /icescreams/1.json
  def update
    @icescream = Icescream.find(params[:id])

    respond_to do |format|
      if @icescream.update_attributes(icescream_params)
        format.html { redirect_to @icescream, notice: 'Icescream was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @icescream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /icescreams/1
  # DELETE /icescreams/1.json
  def destroy
    @icescream = Icescream.find(params[:id])
    @icescream.destroy

    respond_to do |format|
      format.html { redirect_to icescreams_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def icescream_params
      params.require(:icescream).permit(:deliciousness, :flavor)
    end
end
