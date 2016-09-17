class Users::ProfileController < Devise::RegistrationsController
  before_action -> { authenticate_user! force: true },
                except: [:show, :projects, :activity]
  before_action :ensure_admin!, only: :toggle_admin
  before_action :set_user
  layout 'profile', except: :edit

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

  def activity
  end

  def info
  end

  def projects
  end

  def edit
    @user = current_user unless current_user.admin?
  end

  def update
    @user = current_user.admin? ? User.find(params[:id]) : current_user
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
      :name, :image, :email, :nickname, :location, :website
    )
  end
end
