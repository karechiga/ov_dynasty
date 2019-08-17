class ChangeTeamOptionToString < ActiveRecord::Migration[5.2]
  def change
    change_column :contract_years, :team_option, :string
  end
end
