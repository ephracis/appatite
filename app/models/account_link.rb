class AccountLink < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |link|
      link.user = User.where(email: auth.info.email).first_or_create do |user|
        user.name = auth.info.name unless user.name
        user.image = auth.info.image unless user.image
      end
    end
  end
end
