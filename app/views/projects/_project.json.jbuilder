json.extract! project, :id, :name, :origin, :origin_id, :active, :coverage, :build_state, :created_at, :updated_at
json.url project_url(project, format: :json)
