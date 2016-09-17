require 'backends'

class AccountLink < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    l = where(provider: auth.provider, uid: auth.uid).first_or_create do |link|
      link.user = User.where(email: auth.info.email).first_or_create do |user|
        user.name = auth.info.name
        user.image = auth.info.image
        user.nickname = auth.info.nickname
        user.location = auth.info.location
        user.website = auth.info.urls.values.first if auth.info.urls.present?
      end
    end

    # update tokens at every sign in
    l.token = auth.credentials.token
    l.secret = auth.credentials.secret
    l.expires = auth.credentials.expires
    l.expires_at = auth.credentials.expires_at
    l.save
    l
  end

  delegate :projects, to: :backend

  def backend
    @backend ||= load_backend
  end

  private

  def load_backend
    case provider
    when 'github'
      load_github_backend
    when 'gitlab'
      load_gitlab_backend
    else
      raise "Could not find backend for provider '#{provider}'"
    end
  end

  def load_github_backend
    Appatite::Backends::Github.new(
      'https://api.github.com',
      ApplicationSetting.current.github_id || ENV['GITHUB_ID'],
      ApplicationSetting.current.github_secret || ENV['GITHUB_SECRET'],
      token
    )
  end

  def load_gitlab_backend
    Appatite::Backends::Gitlab.new(
      ApplicationSetting.current.gitlab_url || 'https://gitlab.com/api/v3',
      ApplicationSetting.current.gitlab_id || ENV['GITLAB_ID'],
      ApplicationSetting.current.gitlab_secret || ENV['GITLAB_SECRET'],
      token
    )
  end
end
