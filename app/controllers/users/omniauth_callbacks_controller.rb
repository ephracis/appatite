class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    unless ApplicationSetting.current.github_enabled
      redirect_to(root_path, notice: 'GitHub authentication is disabled') && return
    end
    sign_in_with_oauth 'GitHub'
  end

  def gitlab
    unless ApplicationSetting.current.gitlab_enabled
      redirect_to(root_path, notice: 'GitLab authentication is disabled') && return
    end
    sign_in_with_oauth 'GitLab'
  end

  def failure
    redirect_to new_user_session_path
  end

  def setup
    ApplicationSetting.current.setup_omniauth request.env['omniauth.strategy']
    head 404
  end

  protected

  def sign_in_with_oauth(kind)
    @user = AccountLink.from_omniauth(request.env['omniauth.auth']).user
    @user.update_attribute(:is_admin, true) if User.count == 1
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end
end
