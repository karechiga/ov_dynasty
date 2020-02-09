class League < ApplicationRecord
  belongs_to :user
  has_many :memberships
  has_many :rosters
  has_many :schedules

  after_create :initialize_rosters

  def initialize_rosters
    for i in 1..self.num_teams
      if i == 1
        rosters.create(user: user)
      else
        rosters.create()
      end
    end
  end

  def open_roster?
    self.rosters.where(:user => nil).length > 0
  end


end
