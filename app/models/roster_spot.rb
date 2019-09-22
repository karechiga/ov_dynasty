class RosterSpot < ApplicationRecord
  belongs_to :roster
  has_one :player_association

  def player_is_valid?(player)
    position = player.primary_position
    return self.player_association == nil && ((self.position == "Bench") || 
    (self.position == "DL" && player.years_pro <= 1) || (self.position == position.upcase) || 
    (position == 'G' && (self.position == 'SG' || self.position == 'PG')) ||
    (position == 'F' && (self.position == 'SF' || self.position == 'PF')) ||
    ((position == 'G/F' || position == 'F/G') && (self.position == 'SG' || self.position == 'PG' || self.position == 'SF' || self.position == 'PF' || self.position == 'F' || self.position == 'G')) ||
    ((position == 'F/C' || position == 'C/F') && (self.position == 'F' || self.position == 'C' || self.position == 'SF' || self.position == 'PF')))
  end
end
