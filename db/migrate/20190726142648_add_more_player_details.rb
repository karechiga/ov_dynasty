class AddMorePlayerDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :years_pro, :integer
    add_column :players, :college, :string
    add_column :players, :country, :string
    add_column :players, :date_of_birth, :string
    add_column :players, :height_feet, :integer
    add_column :players, :height_inches, :integer
    add_column :players, :weight_pounds, :decimal
    add_index :players, :college
    add_index :players, :country
    add_index :players, :date_of_birth
  end
end
