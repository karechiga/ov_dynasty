class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.float :home_score, default: 0.0
      t.float :away_score, default: 0.0
      t.string :date
      t.integer :matchup_id
      t.index :matchup_id
      t.index :date
      t.timestamps
    end
  end
end
