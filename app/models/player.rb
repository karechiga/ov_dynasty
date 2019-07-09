class Player < ApplicationRecord
  belongs_to :roster, optional: true
end
