class Roster < ApplicationRecord
  belongs_to :league
  belongs_to :user
  has_many :players
  has_many :picks

  after_initialize :init_name
  after_create :init_picks

  def init_name
    if self.new_record?
      self.team_name = "Team #{user.last_name}"
      if user.last_name.length <= 3
        self.team_abbrev = user.last_name.upcase
      else
        self.team_abbrev = user.last_name[0, 3].upcase
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

end
