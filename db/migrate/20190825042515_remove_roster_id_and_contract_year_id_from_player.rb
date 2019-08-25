class RemoveRosterIdAndContractYearIdFromPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :contract_years, :association_id, :integer
    add_index :contract_years, :association_id
    add_index :associations, :roster_id
    add_index :associations, :player_id
    remove_column :players, :roster_id, :integer
    remove_column :contract_years, :player_id
  end
end
