class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:github, :gitlab]
  devise :trackable

  has_many :account_links
  has_many :projects

  validates :email, uniqueness: true

  acts_as_follower

  def self.new_with_session(params, session)
    super.tap do |_user|
    end
  end

  def admin?
    is_admin
  end
end
