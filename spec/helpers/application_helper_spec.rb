require 'rails_helper'

describe ApplicationHelper do
  describe 'current_controller?' do
    it 'should return true when controller matches argument' do
      stub_controller_name('foo')

      expect(helper.current_controller?(:foo)).to eq true
    end

    it 'should return false when controller does not match argument' do
      stub_controller_name('foo')

      expect(helper.current_controller?(:bar)).to eq false
    end

    it 'should take any number of arguments' do
      stub_controller_name('foo')

      expect(helper.current_controller?(:baz, :bar)).to eq false
      expect(helper.current_controller?(:baz, :bar, :foo)).to eq true
    end

    def stub_controller_name(value)
      allow(helper.controller).to receive(:controller_name).and_return(value)
    end
  end

  describe 'current_action?' do
    it 'should return true when action matches' do
      stub_action_name('foo')

      expect(helper.current_action?(:foo)).to eq true
    end

    it 'should return false when action does not match' do
      stub_action_name('foo')

      expect(helper.current_action?(:bar)).to eq false
    end

    it 'should take any number of arguments' do
      stub_action_name('foo')

      expect(helper.current_action?(:baz, :bar)).to eq false
      expect(helper.current_action?(:baz, :bar, :foo)).to eq true
    end

    def stub_action_name(value)
      allow(helper).to receive(:action_name).and_return(value)
    end
  end

  describe 'admin?' do
    it 'should return true when no users exist' do
      expect(User).to receive(:count).and_return 0
      expect(helper.admin?).to eq true
    end

    it 'should return true when signed in as admin' do
      user = create :user, is_admin: true
      allow(helper).to receive(:current_user).and_return user
      expect(helper.admin?).to eq true
    end

    it 'should return false when signed in as user' do
      user = create :user, is_admin: false
      allow(helper).to receive(:current_user).and_return user
      expect(helper.admin?).to eq false
    end

    it 'should return false when not signed in' do
      create :user
      allow(helper).to receive(:current_user).and_return nil
      expect(helper.admin?).to eq false
    end
  end
end
