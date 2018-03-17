# frozen_string_literal: true

module Generator
  CollectEvents = Struct.new(
    :time_range,
    :facebook_groups,
    :repeating_groups
  ) do
    def events
      @events ||= begin
                    logger = Logger.new(STDOUT)
                    scraped_events = []
                    scraped_events += Scrapers::Repeated
                                      .new(repeating_groups)
                                      .run!(start_time, end_time)
                                      .events
                    scraped_events += Scrapers::Facebook
                                      .new(facebook_groups)
                                      .run!(start_time)
                                      .events

                    logger.info "Filtering events based:"
                    logger.info "\tstart_time: #{start_time}"
                    logger.info "\tend_time: #{end_time}"

                    scraped_events
                      .sort_by(&:timestamp)
                      .each { |event| logger.info "event: #{event.title} @ #{event.timestamp}" }
                      .reject { |event| event.timestamp < start_time }
                      .reject { |event| event.timestamp > end_time }
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
