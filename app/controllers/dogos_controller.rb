class DogosController < ApplicationController
  # GET /dogos
  # GET /dogos.json
  def index
    @dogos = Dogo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dogos }
    end
  end

  # GET /dogos/1
  # GET /dogos/1.json
  def show
    @dogo = Dogo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dogo }
    end
  end

  # GET /dogos/new
  # GET /dogos/new.json
  def new
    @dogo = Dogo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dogo }
    end
  end

  # GET /dogos/1/edit
  def edit
    @dogo = Dogo.find(params[:id])
  end

  # POST /dogos
  # POST /dogos.json
  def create
    @dogo = Dogo.new(params[:dogo])

    respond_to do |format|
      if @dogo.save
        format.html { redirect_to @dogo, notice: 'Dogo was successfully created.' }
        format.json { render json: @dogo, status: :created, location: @dogo }
      else
        format.html { render action: "new" }
        format.json { render json: @dogo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dogos/1
  # PUT /dogos/1.json
  def update
    @dogo = Dogo.find(params[:id])

    respond_to do |format|
      if @dogo.update_attributes(params[:dogo])
        format.html { redirect_to @dogo, notice: 'Dogo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dogo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogos/1
  # DELETE /dogos/1.json
  def destroy
    @dogo = Dogo.find(params[:id])
    @dogo.destroy

    respond_to do |format|
      format.html { redirect_to dogos_url }
      format.json { head :no_content }
    end
  end
end
