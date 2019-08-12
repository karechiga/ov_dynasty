class AddPlayerId < ActiveRecord::Migration[5.2]
  def change
    add_column :contract_years, :player_id, :integer
  end
end
