class ContractYear < ApplicationRecord
  belongs_to :player_association
  
  after_create :add_new_contract_to_roster
  before_destroy :subtract_contract_from_payroll
  before_destroy :add_contract_to_salary_add
  
  def add_new_contract_to_roster
    r = player_association.roster_spot.roster.roster_salaries.find_by_year(self.season)
    salary = r.player_salary_total + player_association.roster_spot.salary_multiplier * self.salary
    r.update(player_salary_total: salary)
  end
  
  def subtract_contract_from_payroll
    r = player_association.roster_spot.roster.roster_salaries.find_by_year(self.season)
    salary = r.player_salary_total - player_association.roster_spot.salary_multiplier * self.salary
    r.update(player_salary_total: salary)
  end

  def add_contract_to_salary_add
    if !team_option?
      r = player_association.roster_spot.roster.roster_salaries.find_by_year(self.season)
      salary = r.salary_adds + 0.5 * self.salary
      r.update(salary_adds: salary)
    end
  end

  def team_option?
    return self.team_option == 'true'
  end
  # validates :season, presence: true
  # validates :salary, presence: true
  # validates :team_option, presence: true
end
