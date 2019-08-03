class Roster < ApplicationRecord
  belongs_to :league
  belongs_to :user
  has_many :players
  has_many :picks

  after_initialize :init

  def init
    self.team_name ||= "Team #{user.last_name}"
    if user.last_name.length <= 3
      self.team_abbrev ||= user.last_name.upcase
    else
      self.team_abbrev ||= user.last_name[0, 3].upcase
    end
    self.motto ||= ""
    self.cap_space ||= 0.0
    self.penalty ||= 0.0
    self.traded_salary ||= 0.0
    self.wins ||= 0
    self.losses ||= 0
    self.ties ||= 0
  end
end
