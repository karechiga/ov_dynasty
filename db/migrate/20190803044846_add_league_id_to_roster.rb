class AddLeagueIdToRoster < ActiveRecord::Migration[5.2]
  def change
    add_column :rosters, :league_id, :integer
    add_index :rosters, :league_id
  end
end
