require 'active_support/concern'

module Github
  extend ActiveSupport::Concern

  def github_projects
    JSON.parse(get('/user/repos').body).map do |project|
      {
        url: project['html_url'],
        api_url: project['url'],
        id: project['id'],
        name: project['full_name'],
        description: project['description'],
        followers: project['watchers'],
        origin: :github
      }
    end
  end

  def github_url
    'https://api.github.com/'
  end

  def fetch_github_project
    project = JSON.parse(get(api_url).body)
    statuses = JSON.parse(get("repos/#{project['full_name']}/statuses/HEAD").body)
    retval = {
      name: project['full_name'],
      description: project['description']
    }
    retval[:state] = statuses[0]['state'] if statuses.length.positive?
    retval
  end

  def create_github_webhook(url)
    hook_data = {
      name: 'appatite',
      active: true,
      events: [:status],
      config: {
        url: url,
        content_type: :json
      }
    }
    post("#{api_url}/hooks", body: hook_data.to_json)
  end

  def delete_github_webhook(url)
    hooks = JSON.parse(get("#{api_url}/hooks").body)
    hook = hooks.find { |h| h['config']['url'] == url }
    delete("#{api_url}/hooks/#{hook['id']}") if hook
  end

  def receive_github_webhook(payload)
    self.name = payload['repository']['full_name']
    self.description = payload['repository']['description']
    self.build_state = translate_state payload['state']
  end

  def translate_state(state)
    case state
    when 'pending' then 'running'
    when 'passed' then 'success'
    when 'failed' then 'failed'
    else 'unknown'
    end
  end
end
