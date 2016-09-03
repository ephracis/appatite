class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:github, :gitlab]
  devise :trackable

  has_many :account_links

  validates :email, uniqueness: true

  def self.new_with_session(params, session)
    super.tap do |user|
    end
  end

  def admin?
    is_admin
  end
end
