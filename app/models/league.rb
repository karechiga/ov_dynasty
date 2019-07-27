class League < ApplicationRecord
  belongs_to :user
  has_many :memberships
end
