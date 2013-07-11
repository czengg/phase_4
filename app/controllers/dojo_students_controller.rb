class DojoStudentsController < ApplicationController
  # GET /dojo_students
  # GET /dojo_students.json
  def index
    @dojo_students = DojoStudent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dojo_students }
    end
  end

  # GET /dojo_students/1
  # GET /dojo_students/1.json
  def show
    @dojo_student = DojoStudent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dojo_student }
    end
  end

  # GET /dojo_students/new
  # GET /dojo_students/new.json
  def new
    @dojo_student = DojoStudent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dojo_student }
    end
  end

  # GET /dojo_students/1/edit
  def edit
    @dojo_student = DojoStudent.find(params[:id])
  end

  # POST /dojo_students
  # POST /dojo_students.json
  def create
    @dojo_student = DojoStudent.new(params[:dojo_student])

    respond_to do |format|
      if @dojo_student.save
        format.html { redirect_to @dojo_student, notice: 'Dojo student was successfully created.' }
        format.json { render json: @dojo_student, status: :created, location: @dojo_student }
      else
        format.html { render action: "new" }
        format.json { render json: @dojo_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dojo_students/1
  # PUT /dojo_students/1.json
  def update
    @dojo_student = DojoStudent.find(params[:id])

    respond_to do |format|
      if @dojo_student.update_attributes(params[:dojo_student])
        format.html { redirect_to @dojo_student, notice: 'Dojo student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dojo_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dojo_students/1
  # DELETE /dojo_students/1.json
  def destroy
    @dojo_student = DojoStudent.find(params[:id])
    @dojo_student.destroy

    respond_to do |format|
      format.html { redirect_to dojo_students_url }
      format.json { head :no_content }
    end
  end
end
