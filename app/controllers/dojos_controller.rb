class DojosController < ApplicationController
  # GET /Dojos
  # GET /Dojos.json
  def index
    @dojos = Dojo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dojos }
    end
  end

  # GET /Dojos/1
  # GET /Dojos/1.json
  def show
    @dojo = Dojo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dojo }
    end
  end

  # GET /Dojos/new
  # GET /Dojos/new.json
  def new
    @dojo = Dojo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dojo }
    end
  end

  # GET /Dojos/1/edit
  def edit
    @dojo = Dojo.find(params[:id])
  end

  # POST /Dojos
  # POST /Dojos.json
  def create
    @dojo = Dojo.new(params[:Dojo])

    respond_to do |format|
      if @dojo.save
        format.html { redirect_to @dojo, notice: 'Dojo was successfully created.' }
        format.json { render json: @dojo, status: :created, location: @dojo }
      else
        format.html { render action: "new" }
        format.json { render json: @dojo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Dojos/1
  # PUT /Dojos/1.json
  def update
    @dojo = Dojo.find(params[:id])

    respond_to do |format|
      if @dojo.update_attributes(params[:Dojo])
        format.html { redirect_to @dojo, notice: 'Dojo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dojo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Dojos/1
  # DELETE /Dojos/1.json
  def destroy
    @dojo = Dojo.find(params[:id])
    @dojo.destroy

    respond_to do |format|
      format.html { redirect_to Dojos_url }
      format.json { head :no_content }
    end
  end
end
