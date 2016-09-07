class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :set_csrf_cookie_for_ng

  # Ensure that Angular AJAX requests carry the authenticity token
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  # Ensure that the user is signed in and admin
  def ensure_admin
    unless current_user && current_user.admin?
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'You are not allowed to do that.' }
        format.json { render json: { error: 'You need to be admin' }, status: :forbidden }
      end
    end
  end

  # Extend the CSRF verification to allow Angular AJAX calls
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end
end
