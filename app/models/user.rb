class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :roster

  has_many :leagues
  has_many :memberships
  has_many :memberships_to_leagues, through: :memberships, source: :league

  def is_a_member?(league)
    return memberships_to_leagues.include?(league)
  end
  def is_a_member_of_any_league?
    return !memberships.empty?
  end
end
