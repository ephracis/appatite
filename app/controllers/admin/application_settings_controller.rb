class Admin::ApplicationSettingsController < Admin::ApplicationController
  before_action :set_application_setting

  def show
  end

  def update
    if @application_setting.update_attributes(application_setting_params)
      redirect_to admin_application_settings_path,
                  notice: 'Application settings saved successfully'
    else
      render :show
    end
  end

  private

  def set_application_setting
    @application_setting = ApplicationSetting.current
  end

  def application_setting_params
    params.require(:application_setting).permit(
      :gitlab_enabled,
      :gitlab_url,
      :gitlab_id,
      :gitlab_secret,
      :github_enabled,
      :github_id,
      :github_secret,
      :ga_tracking
    )
  end
end
