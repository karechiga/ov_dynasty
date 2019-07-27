class AddLeagueIdToUsersAndUserIdToLeague < ActiveRecord::Migration[5.2]
  def change
    create_table :leagues_users, id: false do |t|
      t.belongs_to :league, index: true
      t.belongs_to :user, index: true
    end
  end
end
