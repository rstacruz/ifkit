module Ifdoc
  class MarkdownExtractor
    def initialize(fn)
      @file = fn
      @contents = File.read(fn)
      @blocks = @contents.split(/\-{4,}/).map { |s| s.strip }
    end

    def blocks
      @blocks.map { |blk|
        CommentBlock.new \
          :content => blk,
          :file => @file,
          :line => 0
      }
    end
  end
end
