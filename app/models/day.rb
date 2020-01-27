class Day < ApplicationRecord
  belongs_to :matchup

  def is_today?
    time = Time.current
    today = Date.today
    yesterday = Date.yesterday
    day_date = Date.parse(self.date)
    if time.hour < 10
      return day_date == yesterday
    else
      return day_date == today
    end
  end
end
