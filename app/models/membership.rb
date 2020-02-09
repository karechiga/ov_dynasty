class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :league

  after_create :update_roster

  def user_is_league_creator
    return self.user == self.league.user
  end

  def update_roster
    roster = league.rosters.find_by_user_id(user)
    roster.new_member
  end
end
