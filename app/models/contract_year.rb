class ContractYear < ApplicationRecord
  belongs_to :player_association
  
  after_save :update_roster_salaries

  def update_roster_salaries
    player_association.update_roster_salary(self.season)
  end


  # validates :season, presence: true
  # validates :salary, presence: true
  # validates :team_option, presence: true
end
