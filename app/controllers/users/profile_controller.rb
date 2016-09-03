class Users::ProfileController < Devise::RegistrationsController
  before_action -> { authenticate_user! force: true }
  before_action :ensure_admin, only: :toggle_admin
  before_action :set_resource

  # Toggle admin flag on a user
  def toggle_admin
    if User.where(is_admin: true).count == 1 && @user.admin?
      render json: { error: 'Cannot remove the last admin' }, status: :unprocessable_entity
    elsif @user.update_attribute(:is_admin, !@user.admin?)
      render json: @user, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @user = current_user unless current_user.admin?
  end

  private

  def set_resource
    @user = User.find params[:id]
  end
end
