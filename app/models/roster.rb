class Roster < ApplicationRecord
  belongs_to :league
  belongs_to :user, optional: :true
  has_many :roster_spots
  has_many :player_associations, through: :roster_spots, source: :player_association
  has_many :players, through: :player_associations, source: :player
  has_many :picks
  has_many :roster_salaries

  after_initialize :init_name
  after_create :init_picks, :init_roster_salaries, :init_default_roster_spots

  def init_name
    if self.new_record?
      if user != nil
        self.team_name = "Team #{user.last_name}"
        if user.last_name.length <= 3
          self.team_abbrev = user.last_name.upcase
        else
          self.team_abbrev = user.last_name[0, 3].upcase
        end
      else
        self.team_name = "Team #{league.rosters.length + 1}"
        self.team_abbrev = "TM#{league.rosters.length + 1}"
      end
    end
  end

  def init_picks
    current_month = Date.today.month
    current_year = Date.today.year
    if current_month > 7
      draft_year = current_year + 1
    else
      draft_year = current_year
    end
    for i in 1..6 do
      for round in 1..3
        self.picks.create(roster_id: self.id, name: self.team_name, year: draft_year, round: round, comment: "")
      end
      draft_year += 1
    end
  end

  def init_roster_salaries
    current_month = Date.today.month
    current_year = Date.today.year
    if current_month > 6
      year = current_year
    else
      year = current_year - 1
    end
    4.times do |i|
      self.roster_salaries.create(year: year + i)
    end
  end

  def init_default_roster_spots
    2.times do
      self.roster_spots.create(position: 'PG', active: true)
    end
    2.times do
      self.roster_spots.create(position: 'SG', active: true)
    end
    2.times do
      self.roster_spots.create(position: 'SF', active: true)
    end
    2.times do
      self.roster_spots.create(position: 'PF', active: true)
    end
    2.times do
      self.roster_spots.create(position: 'C', active: true)
    end
    5.times do
      self.roster_spots.create()  # Defaults to Bench spot
    end
    3.times do
      self.roster_spots.create(position: 'DL', salary_multiplier: 0.5)
    end
    3.times do 
      self.roster_spots.create(position: 'IR', salary_multiplier: 0.5)
    end
    2.times do
      self.roster_spots.create(position: 'Stash', salary_multiplier: 0.0)
    end
  end

  def find_open_spot(player)
    self.roster_spots.each do |spot|
      if spot.player_is_valid?(player)
        return spot
      end
    end
    return nil
  end

  def update_matchup_results(wins, losses, ties)
    self.update(wins: self.wins += wins, losses: self.losses += losses, ties: self.ties += ties)
  end

  def new_member
    team_name = "Team #{user.last_name}"
    if user.last_name.length <= 3
      team_abbrev = user.last_name.upcase
    else
      team_abbrev = user.last_name[0, 3].upcase
    end
    self.update(team_name: team_name, team_abbrev: team_abbrev)
  end

end
