class Player < ApplicationRecord
  belongs_to :roster, optional: true
  belongs_to :nba_team, optional: true
end
