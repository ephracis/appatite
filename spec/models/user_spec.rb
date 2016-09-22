require 'rails_helper'

describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:account_links) }
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:commits) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:nickname).case_insensitive }
  end

  describe '#admin?' do
    it 'should return true for admins' do
      user = create :user, is_admin: true
      expect(user.admin?).to eq(true)
    end

    it 'should return false for non-admins' do
      user = create :user, is_admin: false
      expect(user.admin?).to eq(false)
    end
  end

  describe '#follow' do
    let(:user) { create :user, email: 'foo@bar.com' }
    let(:project) { create :project }

    it 'should follow projects' do
      user.follow project
      expect(project.followers).to include(user)
      expect(user.following_projects).to include(project)
    end
  end

  describe '#stop_following' do
    let(:user) { create :user, email: 'foo@bar.com' }
    let(:project) { create :project }

    before do
      user.follow project
    end

    it 'should unfollow projects' do
      user.stop_following project
      expect(project.followers).to_not include(user)
      expect(user.following_projects).to_not include(project)
    end
  end
end
