class AddPlayerIdToContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :player_id, :integer
  end
end
