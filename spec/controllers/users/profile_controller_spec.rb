require 'rails_helper.rb'

describe Users::ProfileController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'when signed out' do
    %w(show projects activity).each do |action|
      describe "GET #{action}" do
        it 'should render successfully' do
          user = create :user, name: 'Awesome User'
          get action.to_sym, params: { id: user.id }
          expect(response).to be_success
        end
      end
    end
  end

  context 'when signed in as user' do
    let(:user) { create :user, name: 'Awesome User' }

    before do
      sign_in user
    end

    describe 'GET show' do
      it 'should render edit when owner' do
        get :show, params: { id: user.id }
        expect(response.body).to have_content 'Edit'
      end
    end
  end

  context 'when signed in as user' do
    let(:user) { create :user, name: 'Awesome User', is_admin: false }
    let(:admin) { create :user, name: 'Awesome Admin', is_admin: true, email: 'admin@mail.com' }

    before do
      sign_in admin
    end

    describe 'GET show' do
      it 'should render edit when admin' do
        get :show, params: { id: user.id }
        expect(response.body).to have_content 'Edit'
      end
    end
  end
end
