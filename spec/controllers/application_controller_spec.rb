require 'rails_helper.rb'

describe ApplicationController do
  let(:controller) { ApplicationController.new }
  let(:cookies) { Hash.new }

  before do
    allow(controller).to receive(:cookies).and_return cookies
  end

  describe '#set_csrf_cookie_for_ng' do
    it 'should set csrf token when protection is enabled' do
      allow(controller).to receive(:form_authenticity_token).and_return 'test'
      allow(controller).to receive('protect_against_forgery?').and_return true
      controller.send(:set_csrf_cookie_for_ng)
      expect(cookies['XSRF-TOKEN']).to eq('test')
    end

    it 'should not set csrf token when protection is disabled' do
      allow(controller).to receive('protect_against_forgery?').and_return false
      controller.send(:set_csrf_cookie_for_ng)
      expect(cookies['XSRF-TOKEN']).to eq(nil)
    end
  end

  describe '#render_403' do
    it 'should render empty forbidden response' do
      expect(controller).to receive(:head).with :forbidden
      controller.render_403
    end
  end

  describe '#render_404' do
    it 'should render 404 file without layout' do
      expect(controller).to receive(:render).with(
        file: Rails.root.join('public', '404'),
        layout: false,
        status: '404'
      )
      controller.render_404
    end
  end

  describe '#admin?' do
    it 'should return true when no users exist' do
      expect(User).to receive(:count).and_return 0
      expect(controller.admin?).to eq(true)
    end

    it 'should return false when signed in as user' do
      user = create :user, is_admin: false
      allow(controller).to receive(:current_user).and_return(user)
      expect(controller.admin?).to eq(false)
    end

    it 'should return true when signed in as admin' do
      user = create :user, is_admin: true
      allow(controller).to receive(:current_user).and_return(user)
      expect(controller.admin?).to eq(true)
    end
  end
end
