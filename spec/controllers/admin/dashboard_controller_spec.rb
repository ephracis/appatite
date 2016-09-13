require 'rails_helper.rb'

describe Admin::DashboardController do
  render_views

  describe 'GET index' do
    it_behaves_like 'a restricted area', :get, :index
  end

  describe 'GET users' do
    it_behaves_like 'a restricted area', :get, :users
  end

  describe 'GET projects' do
    it_behaves_like 'a restricted area', :get, :projects
  end
end
