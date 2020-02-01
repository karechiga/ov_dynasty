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

  def update_days
    days.each do |day|
      day.update_score
    end
  end

  def update_matchup_score
    home = 0
    away = 0
    days.each do |day|
      home += day.home_score
      away += day.away_score
    end
    self.home_score = home
    self.away_score = away
  end
end
