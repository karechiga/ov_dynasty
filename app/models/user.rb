class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rosters

  has_many :leagues
  has_many :memberships
  has_many :memberships_to_leagues, through: :memberships, source: :league

  def is_a_member?(league)
    return memberships_to_leagues.include?(league)
  end
  def is_a_member_of_any_league?
    return !memberships_to_leagues.empty?
  end
  def is_admin?(league)
    return memberships.find_by_league_id(league.id).admin
  end
  def my_roster(league)
    return rosters.find_by_league_id(league.id)
  end
end
