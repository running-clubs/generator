require 'json'
require_relative './schedule'

module Generator::Presenters
  class EventsMapPresenter < EventsPresenter
    def to_json
      JSON.pretty_generate(events
        .reject { |event| event.location.lat.nil? || event.location.lng.nil? }
        .group_by(&:location)
        .map do |location, events|
                             {
                               location: {
                                 lat: location.lat,
                                 lng: location.lng
                               },
                               events: events.map do |event|
                                 {
                                   title: event.title,
                                   description: event.description,
                                   timestamp: event.timestamp.strftime('%a, %b %d at %l:%M%p'),
                                   url: event.event_url,
                                   group: {
                                     name: event.group_name,
                                     url: event.group_url
                                   }
                                 }
                               end
                             }
                           end)
    end
  end
end
