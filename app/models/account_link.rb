require 'open-uri'

class AccountLink < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  include OauthClient
  include Gitlab
  include Github

  def self.from_omniauth(auth)
    l = where(provider: auth.provider, uid: auth.uid).first_or_create do |link|
      link.user = User.where(email: auth.info.email).first_or_create do |user|
        user.name = auth.info.name unless user.name
        user.image = auth.info.image unless user.image
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

  def projects
    case provider
    when 'gitlab' then gitlab_projects
    when 'github' then github_projects
    else []
    end
  end

  private

  def provider_url
    case provider
    when 'gitlab' then gitlab_url
    when 'github' then github_url
    else super
    end
  end
end
