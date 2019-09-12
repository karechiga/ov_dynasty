class AddSalaryTotalToRosterSalaries < ActiveRecord::Migration[5.2]
  def change
    add_column :roster_salaries, :salary_total, :decimal, default: 0.0
  end
end
