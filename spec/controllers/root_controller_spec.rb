require 'rails_helper.rb'

describe RootController do
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

  describe 'GET crash' do
    it 'should render error message' do
      expect { get :crash }.to raise_error(RuntimeError)
    end
  end
end
