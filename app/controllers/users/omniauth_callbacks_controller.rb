class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with_oauth 'Github'
  end

  def gitlab
    sign_in_with_oauth 'Gitlab'
  end

  def failure
    redirect_to new_user_session_path
  end

  protected

  def sign_in_with_oauth(kind)
    @user = AccountLink.from_omniauth(request.env['omniauth.auth']).user
    @user.update_attribute(:is_admin, true) if User.count == 1
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end
end
