class AddStartDateEndDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :matchups, :date
    add_column :matchups, :start_date, :string
    add_column :matchups, :end_date, :string
    add_index :matchups, :start_date
    add_index :matchups, :end_date
  end
end
