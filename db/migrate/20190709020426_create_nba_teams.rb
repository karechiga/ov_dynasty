class CreateNbaTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :nba_teams do |t|
      t.string :city
      t.string :nickname
      t.string :abbrev
      t.timestamps
    end
  end
end
