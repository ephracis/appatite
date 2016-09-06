class Project < ApplicationRecord
  validates :name, presence: true
  validates :origin, presence: true
  validates :origin_id, presence: true
  validates :origin_id, uniqueness: { scope: :origin }
  validates :api_url, presence: true
  validates :api_url, uniqueness: true
  belongs_to :user

  include OauthClient
  include Gitlab
  include Github

  def refresh
    return unless origin
    meta = fetch_metadata
    self.name = meta[:name]
    self.build_state = meta[:state]
    self.description = meta[:description]
    self.coverage = meta[:coverage].to_f
  end

  def create_hook(url)
    case provider.to_sym
    when :github then create_github_webhook(url)
    when :gitlab then create_gitlab_webhook(url)
    else
      raise "Unsupported OAuth provider #{provider}"
    end
  end

  def delete_hook(url)
    case provider.to_sym
    when :github then delete_github_webhook(url)
    when :gitlab then delete_gitlab_webhook(url)
    else
      raise "Unsupported OAuth provider #{provider}"
    end
  end

  def receive_hook(payload)
    case provider.to_sym
    when :github then receive_github_webhook(payload)
    when :gitlab then receive_gitlab_webhook(payload)
    else
      raise "Unsupported OAuth provider #{provider}"
    end
  end

  private

  def fetch_metadata
    case provider.to_sym
    when :github then fetch_github_project
    when :gitlab then fetch_gitlab_project
    else
      raise "Unsupported OAuth provider #{provider}"
    end
  end

  def token
    account_link.token
  end

  def account_link
    user.account_links.find_by(provider: origin)
  end

  def provider
    origin
  end

  def provider_url
    case provider
    when 'gitlab' then gitlab_url
    when 'github' then github_url
    else super
    end
  end
end
