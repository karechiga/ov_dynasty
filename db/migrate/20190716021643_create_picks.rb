class CreatePicks < ActiveRecord::Migration[5.2]
  def change
    create_table :picks do |t|
      t.string :name
      t.integer :year
      t.integer :round
      t.text :comment
      t.timestamps
    end
    add_index :picks, :name
    add_index :picks, :year
    add_index :picks, :round
  end
end
