class Schedule < ApplicationRecord
  belongs_to :league
  has_many :matchups
end
