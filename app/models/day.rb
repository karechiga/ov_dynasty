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
    score = 0
    home_team.roster_spots.each do |rs|
      if rs.active && rs.player_association != nil
        score = score + rs.player_association.calc_fp(self.date)
      end
    end
    self.home_score = score
    score = 0
    away_team.roster_spots.each do |rs|
      if rs.active && rs.player_association != nil
        score = score + rs.player_association.calc_fp(self.date)
      end
    end
    self.away_score = score

    matchup.update_matchup_score
  end
end
