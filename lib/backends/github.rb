module Appatite::Backends
  class Github < Base
    def projects
      JSON.parse(get('/user/repos').body).map do |project|
        {
          url: project['html_url'],
          api_url: project['url'],
          id: project['id'],
          name: project['full_name'],
          description: project['description'],
          followers: project['watchers'].to_i,
          origin: :github
        }
      end
    end

    def get_project(url)
      project = JSON.parse(get(url).body)
      statuses = JSON.parse(get("repos/#{project['full_name']}/statuses/HEAD").body)
      commits = JSON.parse(get("repos/#{project['full_name']}/commits").body)
      data = parse_project project
      data[:state] = translate_state(statuses[0]['state']) if statuses.length.positive?
      data[:commits] = parse_commits commits
      data
    end

    def create_webhook(project_url, hook_url)
      hook_data = {
        name: 'web',
        active: true,
        events: [:status],
        config: {
          url: hook_url,
          content_type: :json
        }
      }
      post("#{project_url}/hooks", body: hook_data.to_json)
    end

    def delete_webhook(project_url, hook_url)
      hooks = JSON.parse(get("#{project_url}/hooks").body)
      hook = hooks.find { |h| h['config']['url'] == hook_url }
      delete("#{project_url}/hooks/#{hook['id']}") if hook
    end

    def receive_webhook(payload)
      {
        name: payload['repository']['full_name'],
        description: payload['repository']['description'],
        build_state: translate_state(payload['state'])
      }
    end

    private

    def translate_state(state)
      case state
      when 'pending' then 'running'
      when 'success' then 'success'
      when 'failed', 'error' then 'failed'
      else 'unknown'
      end
    end

    def parse_project(project)
      {
        name: project['full_name'],
        description: project['description']
      }
    end

    def parse_commits(commits)
      return unless commits && commits.length.positive?
      commits.map do |commit|
        {
          sha: commit['sha'],
          message: commit['commit']['message'],
          user: {
            email: commit['commit']['author']['email'],
            name: commit['commit']['author']['name'],
            nickname: commit['author']['login'],
            image: commit['author']['avatar_url']
          }
        }
      end
    end
  end
end
