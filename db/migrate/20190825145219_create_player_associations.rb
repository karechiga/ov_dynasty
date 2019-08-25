class CreatePlayerAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :player_associations do |t|
      t.integer :player_id
      t.integer :roster_id
      t.index :player_id
      t.index :roster_id
      t.timestamps
    end
    add_column :contract_years, :player_association_id, :integer
    add_index :contract_years, :player_association_id
    remove_column :contract_years, :association_id
  end
end
