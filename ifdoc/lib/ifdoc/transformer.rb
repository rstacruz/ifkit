require 'nokogiri'
module Ifdoc
  class Transformer
    def initialize(options)
      @html = Nokogiri::HTML(options[:html])
      work_definition_lists!
    end

    def work_definition_lists!
      @html.css('p').each do |para|
        if para.inner_html.match(/^(.*?)\s+::\s+(.*?)$/m)
          para.name = 'dl'
          para.inner_html = "<dt>#{$1}</dt><dd>#{$2}</dd>"
        end
      end
    end

    def html
      @html.at_css('body').inner_html
    end
  end
end
