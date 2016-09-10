class ApplicationSetting < ApplicationRecord
  CACHE_KEY = 'application_setting.last'.freeze

  validates :gitlab_url,
            presence: { message: "can't be blank when Gitlab authentication is enabled" },
            url: true,
            if: :gitlab_enabled

  after_commit do
    Rails.cache.write(CACHE_KEY, self)
  end

  def self.current
    Rails.cache.fetch(CACHE_KEY) do
      create_from_defaults unless ApplicationSetting.last
      ApplicationSetting.last
    end
  end

  def self.expire
    Rails.cache.delete(CACHE_KEY)
  end

  def self.cached
    Rails.cache.fetch(CACHE_KEY)
  end

  def self.create_from_defaults
    create(
      github_enabled: true,
      gitlab_enabled: true,
      gitlab_url: 'https://gitlab.com/api/v3'
    )
  end

  def setup_omniauth(strategy)
    case strategy
    when OmniAuth::Strategies::GitHub
      setup_github_omniauth(strategy)
    when OmniAuth::Strategies::GitLab
      setup_gitlab_omniauth(strategy)
    else
      raise "Unsupported OmniAuth strategy '#{strategy.class}'"
    end
  end

  private

  def setup_github_omniauth(strategy)
    strategy.options[:client_id] = github_id
    strategy.options[:client_secret] = github_secret
  end

  def setup_gitlab_omniauth(strategy)
    strategy.options[:client_id] = gitlab_id
    strategy.options[:client_secret] = gitlab_secret
    strategy.options[:client_options][:site] = gitlab_url
  end
end
