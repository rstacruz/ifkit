module Ifdoc
  class Block
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

    def transformer
      @transformer ||= Transformer.new \
        :html => markdown_as_html
    end

    def valid?
      @valid
    end

    def markdown
      content.
        gsub(/^@? {0,3}\[mixin\] (.*?) ?\((.*?)\)$/i) { |s| to_mixin_heading $1, $2 }.
        gsub(/^@? {0,3}\[(.*?)\] /m) { |s| to_heading($1.downcase) + ' ' }
    end

    # Example CSS
    def src_css
      SubExtractor.new(markdown, "CSS").blocks.map { |b| b.content }.join("\n")
    end

    # Returns
    def markdown_as_html
      @markdown_as_html ||= redcarpet.render(markdown).force_encoding('utf-8')
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
      case str
      when 'group' then '##'
      else '###'
      end
    end

    def redcarpet
      require 'redcarpet'
      Redcarpet::Markdown.new \
        Redcarpet::Render::HTML,
        :fenced_code_blocks => true
    end
  end
end
