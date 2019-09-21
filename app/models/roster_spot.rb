class RosterSpot < ApplicationRecord
  belongs_to :roster
  has_one :player_association

  def player_is_valid?(position)
    return self.player_association == nil && ((self.position == "Bench") || (self.position == position.upcase) || 
    (position == 'G' && (self.position == 'SG' || self.position == 'PG')) ||
    (position == 'F' && (self.position == 'SF' || self.position == 'PF')) ||
    ((position == 'G/F' || position == 'F/G') && (self.position == 'SG' || self.position == 'PG' || self.position == 'SF' || self.position == 'PF' || self.position == 'F' || self.position == 'G')) ||
    ((position == 'F/C' || position == 'C/F') && (self.position == 'F' || self.position == 'C' || self.position == 'SF' || self.position == 'PF')))
  end

end
