module Ifdoc
  # A Block comment
  #
  #     block.level               #=> 3 (based on <h3>)
  #
  #     block.name                #=> "Block forms (and things)"
  #     block.id                  #=> "block_forms"
  #     block.main_type           #=> "section"
  #
  #     block.example_css         # All CSS from examples
  #
  class Block
    extend AttrCacheable

    attr_reader :file
    attr_reader :line
    attr_reader :content

    def initialize(coblock)
      if coblock.to_s =~ /^@ *(.*)$/m
        @content = $1
        @file = coblock.file
        @line = coblock.line + @content.split("\n").size
        @valid = true
      else
        @valid = false
      end
    end

    def level
      html.match(/<[hH]([123456])>/) && $1.to_i
    end

    def name
      # "Things there (and here)" => "things_there"
      headings.first
    end

    def id
      name && name.scan(/[A-Za-z0-9\-]+/).join('_').downcase
    end

    def headings
      content.scan(/^@? {0,3}\[.*?\] (.*?)(?:\(.*)?$/).flatten
    end

    def main_type
      content.match(/^@? {0,3}\[(.*?)\]/) && $1.downcase
    end

    def transformer
      @transformer ||= Transformer.new \
        :html => markdown_as_html
    end

    def valid?
      @valid
    end

    def markdown
      content.
        gsub(/^@? {0,3}\[mixin\] (.*?) ?(?:\((.*?)\))?$/i) { |s| to_mixin_heading $1, $2 }.
        gsub(/^@? {0,3}\[(.*?)\] /m) { |s| to_heading($1.downcase) + ' ' }
    end

    # Example CSS
    def example_css
      transformer.examples.map { |ex| ex.css }.join "\n"
    end

    # Returns
    def markdown_as_html
      redcarpet.render(markdown).force_encoding('utf-8')
    end

    def html
      transformer.html
    end

    def to_s
      html
    end

    def inspect
      to_s.inspect
    end

  private

    def to_mixin_heading(name, params)
      if params.to_s.size > 0
        "### @include #{name} *(#{params})*"
      else
        "### @include #{name}"
      end
    end

    def to_heading(str)
      level = case str
        when 'intro' then 1
        when 'group' then 2
        else 3
        end

      '#' * level
    end

    def redcarpet
      require 'redcarpet'
      Redcarpet::Markdown.new \
        Redcarpet::Render::HTML,
        :fenced_code_blocks => true
    end

    attr_cacheable \
      :level, :name, :id, :headings, :main_type, :transformer, :valid?,
      :markdown, :example_css, :markdown_as_html, :html
  end
end
