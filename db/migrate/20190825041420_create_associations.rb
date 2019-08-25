class CreateAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :associations do |t|
      t.integer :player_id
      t.integer :roster_id
      t.timestamps
    end
  end
end
