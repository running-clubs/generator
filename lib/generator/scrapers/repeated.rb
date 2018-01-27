module Generator::Scrapers
  Repeated = Struct.new(:repeated_events) do
    attr_reader :events

    def run!(start_time, end_time)
      @events = repeated_events.map do |repeated_event|
        schedule = IceCube::Schedule.new(now = start_time) do |s|
          s.add_recurrence_rule(repeated_event.rule.to_rule)
        end
        schedule.occurrences(end_time).map do |scheduled_time|
          RepeatedEvent.new(
            repeated_event.name,
            scheduled_time,
            repeated_event.url,
            repeated_event.group
          )
        end
      end.flatten
      self
    end
  end
end
