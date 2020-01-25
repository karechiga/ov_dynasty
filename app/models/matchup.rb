class Matchup < ApplicationRecord
  belongs_to :schedule
  has_many :days

  after_create :create_days

  def create_days
    date = Date.parse(self.start_date)
    while date.to_s != self.end_date
      days.create(date: date.to_s)
      date = date.tomorrow
    end
    days.create(date: self.end_date)
  end

  def home_team
    Roster.find(self.home_roster_id)
  end

  def away_team
    Roster.find(self.away_roster_id)
  end
end
