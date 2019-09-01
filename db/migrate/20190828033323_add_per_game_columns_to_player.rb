class AddPerGameColumnsToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :mpg, :decimal
    add_column :players, :ppg, :decimal
    add_column :players, :rpg, :decimal
    add_column :players, :apg, :decimal
    add_column :players, :spg, :decimal
    add_column :players, :bpg, :decimal
    add_column :players, :topg, :decimal
    add_column :players, :fg_perc, :decimal
    add_column :players, :fg3_perc, :decimal
    add_column :players, :ft_perc, :decimal
    add_column :players, :fppg, :decimal
  end
end
