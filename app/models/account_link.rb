require 'open-uri'

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

  def projects
    case provider
    when 'gitlab' then gitlab_projects
    when 'github' then github_projects
    else []
    end
  end

  private

  def gitlab_projects
    resp = open("https://gitlab.com/api/v3/projects?access_token=#{token}").read
    JSON.parse(resp).map do |project|
      {
        id: project['id'],
        name: project['path_with_namespace'],
        description: project['description'],
        url: project['web_url'],
        followers: project['star_count'],
        origin: :gitlab
      }
    end
  end

  def github_projects
    resp = get('/user/repos').body.to_s
    JSON.parse(resp).map do |project|
      {
        id: project['id'],
        name: project['full_name'],
        description: project['description'],
        url: project['html_url'],
        followers: project['watchers'],
        origin: :github
      }
    end
  end

  def request(http_method, path, *arguments)
    access_token.request(http_method, path, *arguments)
  end

  def get(path, headers = {})
    request(:get, path, headers)
  end

  def head(path, headers = {})
    request(:head, path, headers)
  end

  def post(path, body = '', headers = {})
    request(:post, path, body, headers)
  end

  def put(path, body = '', headers = {})
    request(:put, path, body, headers)
  end

  def patch(path, body = '', headers = {})
    request(:patch, path, body, headers)
  end

  def delete(path, headers = {})
    request(:delete, path, headers)
  end

  def client
    return @client if @client
    @client = OAuth2::Client.new(
      ENV["#{provider.upcase}_ID"],
      ENV["#{provider.upcase}_SECRET"],
      site: provider_url
    )
  end

  def access_token
    return @access_token if @access_token
    @access_token = OAuth2::AccessToken.new(client, token)
  end

  def provider_url
    case provider
    when 'gitlab' then 'https://gitlab.com/api/v3/'
    when 'github' then 'https://api.github.com/'
    else raise "Unsupported OAuth provider #{provider}"
    end
  end
end
