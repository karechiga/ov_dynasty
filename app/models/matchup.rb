class Matchup < ApplicationRecord
  belongs_to :schedule

  def home_team
    Roster.find(self.home_roster_id)
  end

  def away_team
    Roster.find(self.away_roster_id)
  end
end
