# frozen_string_literal: true

module Generator::Presenters
  FacebookEventPresenter = Struct.new(:event) do
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
      event.description
    end

    def event_url
      "https://facebook.com/#{event.id}"
    end

    def group_url
      "https://facebook.com/#{event.group.id}"
    end

    def location
      event.location
    end

    def image_url
      event.image_url
    end
  end
end
