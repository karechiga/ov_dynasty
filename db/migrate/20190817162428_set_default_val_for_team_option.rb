class SetDefaultValForTeamOption < ActiveRecord::Migration[5.2]
  def change
    change_column_default :contract_years, :team_option, 'false'
  end
end
