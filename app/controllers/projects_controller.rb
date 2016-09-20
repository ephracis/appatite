class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: :webhook
  before_action :set_project, only: [:edit, :update]
  skip_before_action :verify_authenticity_token, only: :webhook

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.following_projects.where(active: true).order(:id)
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

  # POST /projects/webhook.json
  def webhook
    if request.headers['X-GitHub-Event']
      api_url = params[:repository][:url]
    elsif params[:project]
      base_url = ApplicationSetting.current.gitlab_url
      api_url = "#{base_url}/api/v3/projects/#{params[:project][:id]}"
    else
      render(json: { error: 'Could not recognize the request' },
             status: :unprocessable_entity) && return
    end
    project = Project.find_by(api_url: api_url)
    project&.receive_hook(params)
    if project&.save
      ProjectChannel.broadcast_to project.user, project
      head :ok
    else
      format.json { render json: project.errors, status: :unprocessable_entity }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find params[:id]
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.where(api_url: project_params[:api_url])
                      .first_or_initialize do |p|
      p.assign_attributes(project_params)
      p.user = current_user
    end
    @project.refresh
    @project.active = true

    respond_to do |format|
      if @project.save
        current_user.follow @project
        @project.create_hook(webhook_projects_url) # TODO: send notification on error
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
    old_state = @project.active
    respond_to do |format|
      if @project.update(project_params)
        if old_state != @project.active && @project.active
          @project.create_hook(webhook_projects_url)
        elsif old_state != @project.active
          @project.delete_hook(webhook_projects_url)
        end
        ProjectChannel.broadcast_to @project.user, @project
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
    @project = get_project_from_collection(Project)
    notice, redirect_url = unfollow_project

    if current_user.admin? && params[:force]
      notice, redirect_url = destroy_project

    elsif @project.user == current_user && @project.followers_count.zero?
      notice, redirect_url = deactivate_project
    end

    respond_to do |format|
      format.html { redirect_to redirect_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = get_project_from_collection(
      current_user.admin? ? Project : current_user.projects
    )
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_project_from_collection(projects)
    if params[:api_url]
      projects.find_by api_url: params[:api_url]
    elsif params[:origin] && params[:origin_id]
      projects.find_by(
        origin: params[:origin],
        origin_id: params[:origin_id]
      )
    else
      projects.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(
      :active, :origin, :origin_id, :coverage, :build_state, :name, :api_url
    )
  end

  def unfollow_project
    current_user.stop_following @project
    ["You stopped following #{@project.name}", project_url(@project)]
  end

  def deactivate_project
    @project.delete_hook(webhook_projects_url)
    @project.update_attribute(:active, false)
    ['Project was successfully deactivated', projects_url]
  end

  def destroy_project
    @project.delete_hook(webhook_projects_url)
    @project.destroy
    ['Project was successfully destroyed', projects_url]
  end
end
