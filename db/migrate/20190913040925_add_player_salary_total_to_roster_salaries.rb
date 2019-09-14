class AddPlayerSalaryTotalToRosterSalaries < ActiveRecord::Migration[5.2]
  def change
    add_column :roster_salaries, :player_salary_total, :decimal, default: 0.0
  end
end
