class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def overview
    @recent_users = User.limit(3).order(created_at: :desc)
    @recent_projects = Project.limit(3).order(created_at: :desc)
  end

  def users
    @users = User.order(created_at: :desc)
  end

  def projects
    @projects = Project.order(created_at: :desc)
  end

  def settings
  end
end
