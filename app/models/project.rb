require 'backends'

class Project < ApplicationRecord
  validates :name, presence: true
  validates :origin, presence: true
  validates :origin_id, presence: true
  validates :origin_id, uniqueness: { scope: :origin }
  validates :api_url, presence: true
  validates :api_url, uniqueness: true
  belongs_to :user

  acts_as_followable

  def refresh
    return unless origin
    meta = backend.get_project(api_url)
    self.name = meta[:name]
    self.build_state = meta[:state]
    self.description = meta[:description]
    self.coverage = meta[:coverage].to_f
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

  private

  def token
    account_link.token
  end

  def account_link
    raise 'Missing user attribute' unless user
    user.account_links.find_by(provider: origin)
  end

  def provider
    origin
  end

  def backend
    account_link.backend
  end
end
