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
      data = {
        name: project['full_name'],
        description: project['description']
      }
      if statuses.length.positive?
        data[:state] = translate_state(statuses[0]['state'])
      end
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
      when 'failed' then 'failed'
      else 'unknown'
      end
    end
  end
end
