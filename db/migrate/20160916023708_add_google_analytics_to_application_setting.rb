class AddGoogleAnalyticsToApplicationSetting < ActiveRecord::Migration[5.0]
  def change
    add_column :application_settings, :ga_tracking, :string
  end
end
