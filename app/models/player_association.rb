class PlayerAssociation < ApplicationRecord
  belongs_to :player
  belongs_to :roster_spot

  has_many :contract_years
end
