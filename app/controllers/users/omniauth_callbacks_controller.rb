class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = AccountLink.from_omniauth(request.env['omniauth.auth']).user
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
  end

  def gitlab
    @user = AccountLink.from_omniauth(request.env['omniauth.auth']).user
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Gitlab') if is_navigational_format?
  end

  def failure
    redirect_to new_user_session_path
  end
end
