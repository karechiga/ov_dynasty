class Day < ApplicationRecord
  belongs_to :matchup

  def is_today?
    time = Time.current
    today = Date.today
    yesterday = Date.yesterday
    day_date = Date.parse(self.date)
    if time.hour < 10
      return day_date == yesterday
    else
      return day_date == today
    end
  end

  def update_score
    home_team = matchup.home_team
    away_team = matchup.away_team
    home = 0
    home_team.roster_spots.each do |rs|
      if rs.active && rs.player_association != nil
        home = home + rs.player_association.calc_fp(self.date)
      end
    end
    away = 0
    away_team.roster_spots.each do |rs|
      if rs.active && rs.player_association != nil
        away = away + rs.player_association.calc_fp(self.date)
      end
    end
    self.update(home_score: home, away_score: away)
    matchup.update_matchup_score
  end
end
