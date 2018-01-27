module Generator::Presenters
  EventsPresenter = Struct.new(:events) do
    def events
      @events ||= self['events'].map do |event|
        case event
        when FacebookEvent then FacebookEventPresenter.new event
        when RepeatedEvent then RepeatedEventPresenter.new event
        else
          raise 'There is no presenter here'
        end
      end
    end
  end
end
