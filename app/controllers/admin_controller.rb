class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def overview
  end

  def users
    @users = User.limit(10).order(:created_at)
  end

  def projects
    @projects = Project.all
  end

  def settings
  end
end
