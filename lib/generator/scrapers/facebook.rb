# frozen_string_literal: true

require 'http'
require 'json'

module Generator::Scrapers
  Facebook = Struct.new(:groups) do
    attr_reader :events

    def run!(start_time)
      @events = []
      groups.each do |group|
        # grab acccess token from https://developers.facebook.com/tools/accesstoken/
        response = HTTP
                   .get(
                     "https://graph.facebook.com/#{group.id}/events",
                     params: {
                       fields: 'id,type,event_times,description,name,cover,start_time,place',
                       since: start_time.utc.iso8601,
                       access_token: ENV.fetch('ACCESS_TOKEN')
                     }
                   )

        next if response.code != 200

        @events += JSON.parse(response.body)['data'].select do |event|
          event['type'] == 'public'
        end.map do |event|
          create_event(event, group)
        end.flatten
      end
      self
    end

    private def create_event(event, group)
      start_times = [event.fetch('start_time')]
      start_times += event.fetch('event_times', []).collect { |t| t['start_time'] }
      start_times.map do |start_time|
        FacebookEvent.new(
          event.fetch('id'),
          Time.parse(start_time),
          event.fetch('name'),
          event.fetch('description', 'No description was provided. Please see the even link for more information.'),
          Location.new(
            event.dig('place', 'location', 'latitude'),
            event.dig('place', 'location', 'longitude')
          ),
          event.dig('cover', 'source'),
          group
        )
      end
    end
  end
end
