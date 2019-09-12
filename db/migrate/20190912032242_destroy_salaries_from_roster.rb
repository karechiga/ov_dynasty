class DestroySalariesFromRoster < ActiveRecord::Migration[5.2]
  def change
    remove_column :rosters, :cap_space, :decimal
    remove_column :rosters, :penalty, :decimal
    remove_column :rosters, :traded_salary, :decimal
  end
end
