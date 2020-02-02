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
    self.update(home_score: home, away_score: away)
  end

  def set_active
    self.update(result: "active")
  end
  def update_result
    if self.result != "complete"
      if self.home_score > self.away_score
        home = 1
        away = 0
        tie = 0
      elsif self.home_score < self.away_score
        home = 0
        away = 1
        tie = 0
      else
        home = 0
        away = 0
        tie = 1
      end
      home_team.update_matchup_results(home, away, tie)
      away_team.update_matchup_results(away, home, tie)
      self.update(result: "complete")
    end
  end
end
