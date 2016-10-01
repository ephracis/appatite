require 'rails_helper.rb'

describe ProjectsController do
  render_views

  context 'when signed out' do
    describe 'GET index' do
      it 'should redirect to login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET setup' do
      it 'should redirect to login page' do
        get :setup
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET show' do
      it 'should redirect to login page' do
        get :show, params: { id: 123 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET edit' do
      it 'should redirect to login page' do
        get :edit, params: { id: 123 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST create' do
      it 'should redirect to login page' do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH update' do
      it 'should redirect to login page' do
        patch :update, params: { id: 123 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE destroy' do
      it 'should redirect to login page' do
        delete :destroy, params: { id: 123 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'when signed in as user' do
    let(:user) { create :user, is_admin: false, email: 'foo@bar.com' }

    before do
      sign_in user
    end

    describe 'GET index' do
      it 'should redirect to setup if not following any projects' do
        get :index
        expect(response).to redirect_to(setup_projects_path)
      end

      it 'should render project list if following any active projects' do
        user.follow(create(:project, active: true))
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe 'GET setup' do
      it 'should render project setup page' do
        get :setup
        expect(response.status).to eq(200)
      end
    end

    describe 'POST webhook' do
      it 'should recognize github status hook' do
        project = create :project, api_url: 'http://api.com/foo'
        expect(Project).to receive(:find_by)
          .with(api_url: project.api_url)
          .and_return project
        expect(project).to receive(:receive_hook)
        request.headers['X-GitHub-Event'] = 'status'
        post :webhook, params: {
          repository: { url: 'http://api.com/foo' },
          format: :json
        }
        expect(response.status).to eq(200)
      end

      it 'should recognize gitlab hook' do
        create :application_setting, gitlab_url: 'http://git.io'
        project = create :project, api_url: 'http://git.io/api/v3/projects/1337'
        expect(Project).to receive(:find_by)
          .with(api_url: project.api_url)
          .and_return project
        expect(project).to receive(:receive_hook)
        post :webhook, params: {
          project: { id: 1337 },
          format: :json
        }
        expect(response.status).to eq(200)
      end

      it 'should render error on unrecognized request' do
        post :webhook, params: { foo: 1, format: :json }
        expect(response.status).to eq(422)
      end
    end

    describe 'GET show' do
      it 'should render project' do
        project = create :project
        get :show, params: { id: project.id }
        expect(response.status).to eq(200)
      end

      it 'should render project json' do
        project = create :project, user: user
        get :show, params: { id: project.id, format: :json }
        expect(response.status).to eq(200)
        expect(json['id']).to eq(project.id)
        expect(json['name']).to eq(project.name)
      end

      # TODO: test not found with 'shared example'
    end

    describe 'GET edit' do
      it 'should render not found unless owner' do
        project = create :project
        expect(project.user).to_not eq(user)
        get :edit, params: { id: project.id }
        expect(response.status).to eq(404)
      end

      it 'should render success if owner' do
        project = create :project, user: user
        expect(project.user).to eq(user)
        get :edit, params: { id: project.id }
        expect(response.status).to eq(200)
      end
    end

    describe 'POST create' do
      it 'should create new project' do
        ActiveJob::Base.queue_adapter = :test
        expect_any_instance_of(Project).to receive(:create_hook)
        expect do
          post :create, params: {
            project: {
              api_url: 'http://api.io/123',
              origin: 'gitlab',
              origin_id: 123,
              name: 'test/project'
            }
          }
        end.to change { Project.count }
        expect(response.status).to eq(302)
        expect(Project.last.name).to eq('test/project')
        expect(RefreshProjectJob).to have_been_enqueued
      end

      it 'should activate existing' do
        project = create :project, api_url: 'http://api.io/123'
        ActiveJob::Base.queue_adapter = :test
        expect_any_instance_of(Project).to receive(:create_hook)
        expect do
          post :create, params: {
            project: {
              api_url: 'http://api.io/123',
              origin: 'gitlab',
              origin_id: 123,
              name: 'test/project'
            }
          }
        end.to_not change { Project.count }
        expect(response.status).to eq(302)
        expect(project.name).to eq('test/project')
        expect(RefreshProjectJob).to have_been_enqueued
      end
    end

    describe 'PATCH update' do
      it 'should render not found unless owner' do
        project = create :project
        expect(project.user).to_not eq(user)
        patch :update, params: { id: project.id, project: {
          name: 'new/name'
        } }
        expect(response.status).to eq(404)
        expect(Project.find(project.id).name).to_not eq('new/name')
      end

      it 'should update when owner' do
        expect_any_instance_of(Project).to_not receive(:create_hook)
        expect_any_instance_of(Project).to_not receive(:delete_hook)
        project = create :project, user: user
        expect(project.user).to eq(user)
        patch :update, params: { id: project.id, project: {
          name: 'new/name', active: project.active
        } }
        expect(response.status).to eq(302)
        expect(Project.find(project.id).name).to eq('new/name')
      end

      it 'should create hook when activated' do
        expect_any_instance_of(Project).to receive(:create_hook)
        expect_any_instance_of(Project).to_not receive(:delete_hook)
        project = create :project, user: user, active: false
        expect(project.user).to eq(user)
        patch :update, params: { id: project.id, project: {
          active: true
        } }
      end

      it 'should delete hook when deactivated' do
        expect_any_instance_of(Project).to_not receive(:create_hook)
        expect_any_instance_of(Project).to receive(:delete_hook)
        project = create :project, user: user, active: true
        expect(project.user).to eq(user)
        patch :update, params: { id: project.id, project: {
          active: false
        } }
      end
    end

    describe 'DELETE destroy' do
      it 'should unfollow unless owner' do
        project = create :project, active: true
        user.follow project
        expect(user.following_projects).to include(project)
        expect_any_instance_of(Project).to_not receive(:delete_hook)

        delete :destroy, params: { id: project.id }

        expect(Project.find(project.id).active).to eq(true)
        expect(user.following_projects).to_not include(project)
      end

      it 'should deactivate and unfollow when owner' do
        project = create :project, active: true, user: user
        user.follow project
        expect(user.following_projects).to include(project)
        expect_any_instance_of(Project).to receive(:delete_hook)
          .with('http://test.host/projects/webhook')

        delete :destroy, params: { id: project.id }

        expect(Project.find(project.id).active).to eq(false)
        expect(user.following_projects).to_not include(project)
      end
    end
  end

  context 'when signed in as admin' do
    let(:user) { create :user, is_admin: true, email: 'foo@bar.com' }

    before do
      sign_in user
    end

    describe 'GET edit' do
      it 'should render when not owner' do
        project = create :project
        expect(project.user).to_not eq(user)
        get :edit, params: { id: project.id }
        expect(response.status).to eq(200)
      end
    end

    describe 'PATCH update' do
      it 'should update when not owner' do
        project = create :project
        expect(project.user).to_not eq(user)
        patch :update, params: { id: project.id, project: {
          name: 'new/name'
        } }
        expect(response.status).to eq(302)
        expect(Project.find(project.id).name).to eq('new/name')
      end
    end

    describe 'DELETE destroy' do
      it 'should unfollow unless :force is passed' do
        project = create :project, active: true
        user.follow project
        expect(user.following_projects).to include(project)
        expect_any_instance_of(Project).to_not receive(:delete_hook)

        delete :destroy, params: { id: project.id }

        expect(Project.find(project.id).active).to eq(true)
        expect(user.following_projects).to_not include(project)
      end

      it 'should destroy when :force is passed' do
        project = create :project, active: true, user: user
        user.follow project
        expect(user.following_projects).to include(project)
        expect_any_instance_of(Project).to receive(:delete_hook)
          .with('http://test.host/projects/webhook')

        expect do
          delete :destroy, params: { id: project.id, force: true }
        end.to change { Project.count }

        expect(user.following_projects).to_not include(project)
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end
