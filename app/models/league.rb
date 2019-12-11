class League < ApplicationRecord
  belongs_to :user
  has_many :memberships
  has_many :rosters
  has_many :schedules
end
