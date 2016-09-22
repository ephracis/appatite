require 'backends'

class Project < ApplicationRecord
  validates :name, presence: true
  validates :origin, presence: true
  validates :origin_id, presence: true
  validates :origin_id, uniqueness: { scope: :origin }
  validates :api_url, presence: true
  validates :api_url, uniqueness: true
  validates :api_url, url: true
  belongs_to :user
  has_many :commits
  after_commit :broadcast

  acts_as_followable

  def refresh
    return unless origin
    update_attribute :refreshed_at, Time.current
    meta = backend.get_project(api_url)
    self.name = meta[:name]
    self.build_state = meta[:state]
    self.description = meta[:description]
    self.coverage = meta[:coverage].to_f
    meta[:commits]&.each do |commit_hash|
      commit = Commit.from_hash(commit_hash)
      commit.project = self
      commit.save!
    end
    save!
    update_attribute :refreshed_at, nil
  end

  def create_hook(url)
    return if Rails.env.development?
    backend.create_webhook(api_url, url)
  end

  def delete_hook(url)
    return if Rails.env.development?
    backend.delete_webhook(api_url, url)
  end

  def receive_hook(payload)
    meta = backend.receive_webhook(payload)
    update_attributes meta
  end

  def update_metadata
  end

  private

  def token
    account_link.token
  end

  def account_link
    user.account_links.find_by(provider: origin)
  end

  def provider
    origin
  end

  def backend
    account_link.backend
  end

  def broadcast
    ProjectChannel.broadcast_to self, self
  end
end
