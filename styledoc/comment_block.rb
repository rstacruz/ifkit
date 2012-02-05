module StyleDoc
  class CommentBlock
    attr_reader :file
    attr_reader :line
    attr_accessor :content

    def initialize(options)
      @file    = options[:file]
      @line    = options[:line]
      @content = options[:content]
    end

    def to_s
      @content
    end
  end
end
