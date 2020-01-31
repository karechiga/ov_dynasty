class Player < ApplicationRecord
  belongs_to :nba_team, optional: true
  has_many :games
  has_many :player_associations
  has_many :roster_spots, through: :player_associations, source: :roster_spot
  has_many :rosters, through: :roster_spots, source: :roster
  has_many :leagues, through: :rosters, source: :league

  # after_update :update_per_game

  def is_on_roster?(roster)
    return rosters.include?(roster)
  end
  def is_in_league?(league)
    return leagues.include?(league)
  end
  def has_game_on_date?(date)
    return !games.where(date: date).empty?
  end

  def update_per_game
    self.mpg = self.calc_mpg
    self.ppg = self.calc_ppg
    self.rpg = self.calc_rpg
    self.apg = self.calc_apg
    self.spg = self.calc_spg
    self.bpg = self.calc_bpg
    self.topg = self.calc_topg
    self.fg_perc = self.calc_fg_perc
    self.fg3_perc = self.calc_fg3_perc
    self.ft_perc = self.calc_ft_perc
  end

  

  def calc_mpg
    return (self.min_total.to_f / self.gp.to_f).round(1)
  end
  def calc_ppg
    return (self.pts_total.to_f / self.gp.to_f).round(1)
  end
  def calc_rpg
    return (self.reb_total.to_f / self.gp.to_f).round(1)
  end
  def calc_apg
    return (self.ast_total.to_f / self.gp.to_f).round(1)
  end
  def calc_spg
    return (self.stl_total.to_f / self.gp.to_f).round(2)
  end
  def calc_bpg
    return (self.blk_total.to_f / self.gp.to_f).round(2)
  end
  def calc_topg
    return (self.to_total.to_f / self.gp.to_f).round(2)
  end
  def calc_fg_perc
    fg_perc = (self.fgm_total.to_f / self.fga_total.to_f).round(3)
    return fg_perc.nan? ? 0.00 : fg_perc
  end
  def calc_fgpg
    return self.fgm_total.to_f / self.gp.to_f
  end
  def calc_fgapg
    return self.fga_total.to_f / self.gp.to_f
  end
  def calc_ftpg
    return self.ftm_total.to_f / self.gp.to_f
  end
  def calc_ftapg
    return self.fta_total.to_f / self.gp.to_f
  end
  def calc_fg3_perc
    fg3_perc = (self.fgm3_total.to_f / self.fga3_total.to_f).round(3)
    return fg3_perc.nan? ? 0.00 : fg3_perc
  end
  def calc_ft_perc
    ft_perc = (self.ftm_total.to_f / self.fta_total.to_f).round(3)
    return ft_perc.nan? ? 0.00 : ft_perc
  end
end
