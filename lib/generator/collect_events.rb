module Generator
  CollectEvents = Struct.new(
    :time_range,
    :facebook_groups,
    :repeating_groups
  ) do
    def events
      @events ||= begin
                    scraped_events = []
                    scraped_events += Scrapers::Repeated
                                      .new(repeating_groups)
                                      .run!(start_time, end_time)
                                      .events
                    scraped_events += Scrapers::Facebook
                                      .new(facebook_groups)
                                      .run!(start_time)
                                      .events

                    current_time = Time.now
                    scraped_events
                      .reject { |event| event.timestamp < start_time }
                      .reject { |event| event.timestamp > end_time }
                      .sort_by(&:timestamp)
                      .uniq
                  end
    end

    def start_time
      time_range.begin
    end

    def end_time
      time_range.end
    end
  end
end
