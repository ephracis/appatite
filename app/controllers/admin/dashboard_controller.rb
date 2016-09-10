class Admin::DashboardController < Admin::ApplicationController
  def index
    @recent_users = User.limit(3).order(created_at: :desc)
    @recent_projects = Project.limit(3).order(created_at: :desc)
  end

  def users
    @users = User.order(created_at: :desc)
  end

  def projects
    @projects = Project.order(created_at: :desc)
  end
end
