class CreateRosterSalaries < ActiveRecord::Migration[5.2]
  def change
    create_table :roster_salaries do |t|
      t.integer :year
      t.decimal :salary_cap, default: 0.0
      t.decimal :traded_salary, default: 0.0
      t.decimal :penalty, default: 0.0
      t.decimal :salary_adds, default: 0.0
      t.integer :roster_id
      t.index :roster_id
      t.timestamps
    end
  end
end
