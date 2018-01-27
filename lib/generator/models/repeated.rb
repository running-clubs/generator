require 'ice_cube'

module Generator::Models
  Group            = Struct.new(:name, :url, :location)
  RepeatedSchedule = Struct.new(:name, :rule, :url, :group)
  RepeatedTime     = Struct.new(:day, :hour, :minute) do
    def to_rule
      IceCube::Rule.weekly.day(day).hour_of_day(hour).minute_of_hour(minute).second_of_minute(0)
    end
  end
  RepeatedEvent = Struct.new(
    :title,
    :timestamp,
    :url,
    :group
  )
end
