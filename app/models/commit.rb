class Commit < ApplicationRecord
  belongs_to :user
  belongs_to :project
  validates :sha, presence: true
  validates :sha, format: { with: /\A[a-fA-F0-9]{40}\z/ }

  def self.from_hash(hash)
    hash_dup = hash.dup
    user_hash = hash_dup.delete(:user)
    user = User.find_or_create_by(email: user_hash[:email]) do |u|
      u.update_attributes(user_hash)
    end
    commit = new(hash_dup)
    commit.user = user
    commit
  end

  def title
    return message unless message.present?
    message.split("\n").first
  end
end
