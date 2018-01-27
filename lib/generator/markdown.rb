require 'redcarpet'

module Generator
  class MarkdownRenderer < Redcarpet::Render::HTML
    def autolink(link, _link_type)
      %(<a href="#{link}" title="#{link}" target="_blank" rel="noopener">#{link.gsub(/^(.{45,}?).*$/m, '\1...')}</a>)
    end
  end
end
