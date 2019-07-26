class AddRealSalaryRemoveCurrentStatsFromPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :current_salary, :decimal, default: 0.0
    remove_column :players, :minutes, :integer
    remove_column :players, :points, :integer
    remove_column :players, :rebounds, :integer
    remove_column :players, :assists, :integer
    remove_column :players, :steals, :integer
    remove_column :players, :blocks, :integer
    remove_column :players, :turnovers, :integer
    remove_column :players, :fgm, :integer
    remove_column :players, :fga, :integer
    remove_column :players, :fgm3, :integer
    remove_column :players, :fga3, :integer
    remove_column :players, :ftm, :integer
    remove_column :players, :fta, :integer
  end
end
