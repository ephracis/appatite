class Project < ApplicationRecord
  validates :name, presence: true
  validates :origin, presence: true
  validates :origin_id, presence: true
  validates :origin_id, uniqueness: { scope: :origin }
  belongs_to :user
end
