class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :position
      t.string :name
      t.string :team
      t.string :former_team
      t.integer :minutes
      t.integer :points
      t.integer :rebounds
      t.integer :assists
      t.integer :steals
      t.integer :blocks
      t.integer :turnovers
      t.integer :fgm
      t.integer :fga
      t.integer :fgm3
      t.integer :fga3
      t.integer :ftm
      t.integer :fta
      t.integer :gp
      t.integer :min_total
      t.integer :pts_total
      t.integer :reb_total
      t.integer :ast_total
      t.integer :stl_total
      t.integer :blk_total
      t.integer :to_total
      t.integer :fgm_total
      t.integer :fga_total
      t.integer :fgm3_total
      t.integer :fga3_total
      t.integer :ftm_total
      t.integer :fta_total
      t.integer :roster_id
      t.string :timestamps
      t.timestamps
    end
    add_index :players, :roster_id
  end
end
