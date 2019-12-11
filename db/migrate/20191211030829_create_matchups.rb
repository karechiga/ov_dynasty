class CreateMatchups < ActiveRecord::Migration[5.2]
  def change
    create_table :matchups do |t|
      t.float :home_score, default: 0.0
      t.float :away_score, default: 0.0
      t.string :date
      t.string :result, default: ""
      t.integer :schedule_id
      t.integer :home_roster_id
      t.integer :away_roster_id
      t.timestamps
    end

    add_column :schedules, :league_id, :integer
  end
end
