module Ifdoc
  #   # Instanciated by Transformer
  #   Example.new :html => .., :css => ...
  #
  #   example.html
  #   example.css
  #
  class Example
    attr_reader :html
    attr_reader :css
    attr_reader :js

    def initialize(sections)
      @html = sections[:html]
      @css = sections[:css]
      @js = sections[:js] || sections[:javascript]

      if sections[:html].nil?
        [:haml].each do |type|
          if sections[type]
            @html ||= Tilt.new(type.to_s) { sections[type] }.render
          end
        end
      else
        @Html = sections[:html]
      end

    end

    def html?() ! html.to_s.empty?; end
    def css?()  ! css.to_s.empty?; end
    def js?()   ! js.to_s.empty?; end
  end
end
