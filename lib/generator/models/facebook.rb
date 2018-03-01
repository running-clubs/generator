# frozen_string_literal: true

require_relative '../markdown'

module Generator::Models
  FacebookGroup = Struct.new(:id, :name)
  FacebookEvent = Struct.new(
    :id,
    :timestamp,
    :title,
    :description,
    :location,
    :image_url,
    :group
  ) do

    def description
      @description_markdown ||= markdown(self['description'])
    end

    private def markdown(text)
      Redcarpet::Markdown.new(
        Generator::MarkdownRenderer.new(
          filter_html: true,
          hard_wrap: true
        ),
        autolink: true
      ).render(text)
    end
  end
end
