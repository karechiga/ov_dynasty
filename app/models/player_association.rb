class PlayerAssociation < ApplicationRecord
  belongs_to :player
  belongs_to :roster
  has_many :contract_years
end
