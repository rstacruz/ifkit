require 'nokogiri'
module Ifdoc
  # Represents a block of HTML text.
  # Delegate of block.
  #
  #     Transformer.new :html => "html code goes in"
  #
  #     transformer.examples   # Instances of Example
  #     transformer.html       # Final HTML
  #
  class Transformer
    attr_reader :examples

    def initialize(options)
      @html = Nokogiri::HTML(options[:html])
      @examples = Array.new
      work_definition_lists!
      work_pre_blocks!
      work_examples!
    end

    # Converts <p>x :: y</p> to <dl><dt>x</dt><dd>y</dd></dl>.
    def work_definition_lists!
      @html.css('p').each do |para|
        if para.inner_html.match(/^(.*?)\s+::\s+(.*)$/m)
          para.name = 'dl'
          para.inner_html = "<dt>#{$1}</dt><dd>#{$2}</dd>"
        end
      end
    end

    # Unwrap <pre><code> blocks.
    def work_pre_blocks!
      @html.css('pre').each do |pre|
        if pre.children.size == 1 && pre.children.first.name == 'code'
          pre.inner_html = pre.children.first.inner_html
        end
      end
    end

    # Convert <pre> examples into proper markup.
    def work_examples!
      @html.css('pre').each do |pre|
        lines = pre.content.split("\n")
        first_line = lines.first.to_s.strip
        next  unless first_line.match(/^# ([A-Za-z]+)$/i)

        sections = split_lines(lines)
        example  = Example.new sections
        @examples.push example
        template = Tilt.new(Ifdoc.root('data', 'example.haml'))

        pre.after(template.render(example))
        pre.remove
      end
    end

    def example_css
      examples.map { |ex| ex.css }.join("\n")
    end

    def html
      @html.at_css('body').inner_html
    end

  private
    # Returns a hash of sections in a pre.
    #
    #     split_lines(array of lines)
    #     #=> { :css => "...", :html => "..." }
    #
    def split_lines(lines)
      cur = nil
      re = Hash.new
      lines.each do |line|
        if line.match(/^# ([A-Za-z]+)$/i)
          cur = $1.strip.downcase.to_sym
          re[cur] = Array.new
        else
          re[cur] << line
        end
      end

      re.each { |key, lines| re[key] = lines.join("\n") }
      re
    end
  end
end
