class DropAssociation < ActiveRecord::Migration[5.2]
  def change
    drop_table :associations
  end
end
