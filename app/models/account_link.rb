require 'backends'

class AccountLink < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

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

  delegate :projects, to: :backend

  def backend
    @backend ||= load_backend
  end

  private

  def load_backend
    case provider
    when 'gitlab'
      Appatite::Backends::Gitlab.new(
        'https://gitlab.com',
        ENV['GITLAB_ID'],
        ENV['GITLAB_SECRET'],
        token
      )
    when 'github'
      Appatite::Backends::Github.new(
        'https://api.github.com',
        ENV['GITHUB_ID'],
        ENV['GITHUB_SECRET'],
        token
      )
    else
      raise "Could not find backend for provider '#{provider}'"
    end
  end
end
