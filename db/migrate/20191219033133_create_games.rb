class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :date
      t.integer :player_id
      t.integer :min, default: 0
      t.integer :pts, default: 0
      t.integer :reb, default: 0
      t.integer :ast, default: 0
      t.integer :stl, default: 0
      t.integer :blk, default: 0
      t.integer :to, default: 0
      t.integer :fgm, default: 0
      t.integer :fga, default: 0
      t.integer :fgm3, default: 0
      t.integer :fga3, default: 0
      t.integer :ftm, default: 0
      t.integer :fta, default: 0
      t.index :date
      t.index :player_id
      t.timestamps
    end
  end
end
