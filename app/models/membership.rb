class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :league

  def user_is_league_creator
    return self.user == self.league.user
  end
end
