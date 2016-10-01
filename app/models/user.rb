class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:github, :gitlab]
  devise :trackable

  has_many :account_links
  has_many :projects
  has_many :commits

  validates :email, uniqueness: true
  validates :nickname, uniqueness: { case_sensitive: false }

  acts_as_follower

  def admin?
    is_admin == true
  end
end
