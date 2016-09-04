class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects
    redirect_to(setup_projects_path) && return unless @projects.any?
  end

  # GET /projects/setup
  def setup
    @projects = []
    current_user.account_links.each do |link|
      @projects += link.projects
    end
    active_projects = current_user.projects.where(active: true).map do |p|
      "#{p.origin}-#{p.origin_id}"
    end
    @projects.each do |project|
      uniq_id = "#{project[:origin]}-#{project[:id]}"
      project[:state] =
        uniq_id.in?(active_projects) ? :active : :inactive
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.where(project_params).first_or_initialize do |p|
      p.user = current_user
      p.name = 'Test project'
    end
    @project.active = true

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = if params[:origin] && params[:origin_id]
                 Project.find_by(
                   origin: params[:origin],
                   origin_id: params[:origin_id]
                 )
               else
                 Project.find(params[:id])
               end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:active, :origin, :origin_id)
  end
end
