class ChangeDefaultValuesForRoster < ActiveRecord::Migration[5.2]
  def change
    change_column_default :rosters, :motto, ""
    change_column_default :rosters, :cap_space, 0.0
    change_column_default :rosters, :penalty, 0.0
    change_column_default :rosters, :traded_salary, 0.0
    change_column_default :rosters, :wins, 0.0
    change_column_default :rosters, :losses, 0.0
    change_column_default :rosters, :ties, 0.0
  end
end
