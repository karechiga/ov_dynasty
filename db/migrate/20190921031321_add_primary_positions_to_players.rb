class AddPrimaryPositionsToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :primary_position, :string
  end
end
