module AuthHelper
  def auth_configured?
    (
      ApplicationSetting.current.github_id.present? &&
      ApplicationSetting.current.github_secret.present?
    ) || (
      ApplicationSetting.current.gitlab_id.present? &&
      ApplicationSetting.current.gitlab_secret.present?
    )
  end

  def any_auth?
    github_auth? || gitlab_auth?
  end

  def github_auth?
    ApplicationSetting.current.github_enabled
  end

  def gitlab_auth?
    ApplicationSetting.current.gitlab_enabled
  end
end
