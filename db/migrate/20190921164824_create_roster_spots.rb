class CreateRosterSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :roster_spots do |t|
      t.integer :roster_id
      t.string :position, default: "Bench"
      t.decimal :salary_multiplier, default: 1.0
      t.boolean :locked, default: false
      t.boolean :active, default: false
      t.index :roster_id
      t.timestamps
    end
  end
  remove_column :player_associations, :roster_id, :integer
  add_column :player_associations, :roster_spot_id, :integer
end
