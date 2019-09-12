class PlayerAssociation < ApplicationRecord
  belongs_to :player
  belongs_to :roster
  has_many :contract_years


  def update_roster_salary(year)
    contract_year = contract_years.find_by_season(year)
    r = roster.roster_salaries.find_by_year(year)
    salary = r.salary_total + contract_year.salary
    r.update(salary_total: salary)
  end

end
