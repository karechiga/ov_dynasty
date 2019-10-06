class PlayerAssociation < ApplicationRecord
  belongs_to :player
  belongs_to :roster_spot

  has_many :contract_years

  before_update :update_roster_player_salary

  def update_roster_player_salary
    old_roster_spot = RosterSpot.find(roster_spot_id_was)
    roster_spot.roster.roster_salaries.each do |roster_salary|
      year = roster_salary.year
      contract_year = contract_years.find_by_season(year)
      if contract_year != nil
        salary = roster_salary.player_salary_total - old_roster_spot.salary_multiplier * contract_year.salary + roster_spot.salary_multiplier * contract_year.salary
        roster_salary.update(player_salary_total: salary)
      end
    end
  end
end
