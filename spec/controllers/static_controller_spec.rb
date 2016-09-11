require 'rails_helper.rb'

describe StaticController do
  describe 'GET index' do
    it 'should render front page' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET pricing' do
    it 'should render pricing page' do
      get :pricing
      expect(response).to have_http_status(200)
    end
  end
end
