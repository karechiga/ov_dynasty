class RosterSalary < ApplicationRecord
  belongs_to :roster

  before_update :update_total_salary, unless: :salary_total_changed?

  def update_total_salary
    salary = self.player_salary_total + self.penalty + self.salary_adds + self.traded_salary
    self.update(salary_total: salary)
  end
end
