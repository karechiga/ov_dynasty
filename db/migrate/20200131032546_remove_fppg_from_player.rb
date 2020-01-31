class RemoveFppgFromPlayer < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :fppg
    add_column :player_associations, :fppg, :decimal
  end
end
