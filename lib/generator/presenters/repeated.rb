# frozen_string_literal: true

module Generator::Presenters
  RepeatedEventPresenter = Struct.new(:event) do
    def timestamp
      event.timestamp
    end

    def title
      event.title
    end

    def group_name
      event.group.name
    end

    def description
      'There is no description for this event. Please see the website for more details.'
    end

    def event_url
      event.url
    end

    def group_url
      event.group.url
    end

    def location
      event.group.location
    end

    def image_url
      nil
    end
  end
end
