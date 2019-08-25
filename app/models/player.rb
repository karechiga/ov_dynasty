class Player < ApplicationRecord
  belongs_to :nba_team, optional: true
  has_many :player_associations
  has_many :player_associations_to_rosters, through: :player_associations, source: :roster

  def is_on_roster?(roster)
    return player_associations_to_rosters.include?(roster)
  end
  def is_in_league?(league)
    player_associations_to_rosters.each do |roster|
      if roster.league == league
        return true
      end
    end
    return false
  end

  def mpg
    return (self.min_total.to_f / self.gp.to_f).round(1)
  end
  def ppg
    return (self.pts_total.to_f / self.gp.to_f).round(1)
  end
  def rpg
    return (self.reb_total.to_f / self.gp.to_f).round(1)
  end
  def apg
    return (self.ast_total.to_f / self.gp.to_f).round(1)
  end
  def spg
    return (self.stl_total.to_f / self.gp.to_f).round(2)
  end
  def bpg
    return (self.blk_total.to_f / self.gp.to_f).round(2)
  end
  def topg
    return (self.to_total.to_f / self.gp.to_f).round(2)
  end
  def fg_perc
    return (self.fgm_total.to_f / self.fga_total.to_f).round(3)
  end
  def fgpg
    return self.fgm_total.to_f / self.gp.to_f
  end
  def fgapg
    return self.fga_total.to_f / self.gp.to_f
  end
  def ftpg
    return self.ftm_total.to_f / self.gp.to_f
  end
  def ftapg
    return self.fta_total.to_f / self.gp.to_f
  end
  def fg3_perc
    return (self.fgm3_total.to_f / self.fga3_total.to_f).round(3)
  end
  def ft_perc
    return (self.ftm_total.to_f / self.fta_total.to_f).round(3)
  end
  def fppg
    return (ppg + rpg + apg + spg + bpg - topg + fgpg - fgapg + ftpg - ftapg).round(1)
  end
end
