class ContractYear < ApplicationRecord
  belongs_to :player

  # validates :season, presence: true
  # validates :salary, presence: true
  # validates :team_option, presence: true
end
