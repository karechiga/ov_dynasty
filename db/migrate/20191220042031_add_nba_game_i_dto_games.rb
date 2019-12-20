class AddNbaGameIDtoGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :nba_game_id, :integer
    add_index :games, :nba_game_id
  end
end
