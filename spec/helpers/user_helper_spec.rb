require 'rails_helper'

describe UserHelper do
  describe 'avatar_for' do
    it 'should return icon when blank' do
      user = create :user, image: nil
      expect(helper.avatar_for(user)).to match 'fa-user'
    end

    it 'should return image when set' do
      user = create :user, image: 'http://image.com/jpg'
      expect(helper.avatar_for(user)).to match '<img'
      expect(helper.avatar_for(user)).to match user.image
    end
  end

  describe 'pretty_website' do
    it 'should remove http' do
      expect(helper.pretty_url('http://foo.com/bar')).to eq('foo.com/bar')
    end

    it 'should remove https' do
      expect(helper.pretty_url('https://foo.com/bar')).to eq('foo.com/bar')
    end

    it 'should remove www' do
      expect(helper.pretty_url('https://www.foo.com/bar')).to eq('foo.com/bar')
    end

    it 'should remove trailing slash' do
      expect(helper.pretty_url('https://www.foo.com/bar/')).to eq('foo.com/bar')
    end
  end
end
