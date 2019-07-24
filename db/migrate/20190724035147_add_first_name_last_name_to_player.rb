class AddFirstNameLastNameToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :first_name, :string
    add_column :players, :last_name, :string
    add_index :players, :first_name
    add_index :players, :last_name
  end
end
