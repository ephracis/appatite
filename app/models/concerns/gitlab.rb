require 'active_support/concern'

module Gitlab
  extend ActiveSupport::Concern

  def gitlab_projects
    JSON.parse(get('/api/v3/projects').body).map do |project|
      {
        url: project['web_url'],
        api_url: "https://gitlab.com/api/v3/projects/#{project['id']}",
        id: project['id'],
        name: project['path_with_namespace'],
        description: project['description'],
        followers: project['star_count'],
        origin: :gitlab
      }
    end
  end

  def gitlab_url
    'https://gitlab.com/api/v3/'
  end

  def fetch_gitlab_project
    project = JSON.parse(get(api_url).body)
    builds = JSON.parse(get("/api/v3/projects/#{project['id']}/builds").body)
    retval = {
      name: project['path_with_namespace'],
      description: project['description']
    }
    if builds.length.positive?
      retval[:state] = builds[0]['status']
      retval[:coverage] = builds[0]['coverage']
    end
    retval
  end

  def create_gitlab_webhook(url)
    hook_data = {
      url: url,
      pipeline_events: true
    }
    post("#{api_url}/hooks", body: hook_data.to_json)
  end

  def delete_gitlab_webhook(url)
    hooks = JSON.parse(get("#{api_url}/hooks").body)
    hook = hooks.find { |h| h['url'] == url }
    delete("#{api_url}/hooks/#{hook['id']}") if hook
  end

  def receive_gitlab_webhook(payload)
    self.name = payload['project']['path_with_namespace']
    self.description = payload['project']['description']
    if payload['builds'].length.positive?
      self.build_state = translate_status payload['builds'][0]['status']
    end
  end

  def translate_status(state)
    case state
    when 'pending', 'running' then 'running'
    when 'failed' then 'failed'
    when 'success' then 'success'
    else 'unknown'
    end
  end
end
