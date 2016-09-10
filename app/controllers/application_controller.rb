class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :set_csrf_cookie_for_ng

  # Ensure that AJAX requests carry the authenticity token
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def render_403
    head :forbidden
  end

  def render_404
    render file: Rails.root.join('public', '404'), layout: false, status: '404'
  end

  def admin?
    User.count.zero? || (current_user && current_user.admin?)
  end

  protected

  # Ensure that the user is signed in and admin
  def ensure_admin!
    unless admin?
      respond_to do |format|
        format.html { render_404 }
        format.json { render json: { error: 'You need to be admin' }, status: :forbidden }
      end
    end
  end

  # Extend the CSRF verification to allow AJAX calls
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end
end
