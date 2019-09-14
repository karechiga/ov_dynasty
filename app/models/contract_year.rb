class ContractYear < ApplicationRecord
  belongs_to :player_association
  
  after_create :add_new_contract_to_roster
  before_destroy :subtract_contract_from_payroll
  before_destroy :add_contract_to_salary_add
  
  def add_new_contract_to_roster
    r = player_association.roster.roster_salaries.find_by_year(self.season)
    salary = r.player_salary_total + self.salary
    r.update(player_salary_total: salary)
  end
  
  def subtract_contract_from_payroll
    r = player_association.roster.roster_salaries.find_by_year(self.season)
    salary = r.player_salary_total - self.salary
    r.update(player_salary_total: salary)
  end

  def add_contract_to_salary_add
    r = player_association.roster.roster_salaries.find_by_year(self.season)
    salary = r.salary_adds + 0.5 * self.salary
    r.update(salary_adds: salary)
  end
  # validates :season, presence: true
  # validates :salary, presence: true
  # validates :team_option, presence: true
end
