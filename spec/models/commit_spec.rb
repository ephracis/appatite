require 'rails_helper'

describe Commit, type: :model do
  let(:commit) { create :commit }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:sha) }
    it { is_expected.to allow_value('d6cd1e2bd19e03a81132a23b2025920577f84e37').for(:sha) }
    it { is_expected.to_not allow_value('d6cd1e2bd19e03a81132a23b2025920577f84e3').for(:sha) }
    it { is_expected.to_not allow_value('d6cd1e2bd19e03a81132a23b2025920577f84e3x').for(:sha) }
    it { is_expected.to_not allow_value('d6cd1e2bd19e03a81132a23b2025920577f84e377').for(:sha) }
  end

  describe '.from_hash' do
    it 'should create commit' do
      hash = {
        user: {
          email: 'test@mail.com',
          nickname: 'testnick',
          name: 'Test User',
          image: 'http://foo.com/image.jpg'
        },
        sha: 'testsha',
        created_at: 3.days.ago
      }
      commit = Commit.from_hash(hash)
      expect(commit.sha).to eq(hash[:sha])
      expect(commit.user.name).to eq(hash[:user][:name])
      expect(commit.created_at).to eq(hash[:created_at])
    end
  end

  describe '#title' do
    it 'should return first line in message' do
      commit.message = "First line\nSecond line\nThird line"
      expect(commit.title).to eq('First line')
    end
  end
end
