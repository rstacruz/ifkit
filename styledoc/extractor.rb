module StyleDoc
  class Extractor
    def initialize(file)
      @file  = file
      @regex = /^(?:\/\/|#) ?(.*?)$/
    end

    def blocks
      re = Array.new
      block = Array.new

      (lines + [""]).each_with_index do |line, n|
        if line =~ @regex
          block.push $1
        else
          re.push CommentBlock.new(
            :content => block.join("\n"),
            :file    => @file,
            :line    => n+1)  if block.size > 1

          block = Array.new
        end
      end

      re
    end

    def lines
      @lines ||= File.read(@file).
        force_encoding('utf-8').
        split("\n")
    end
  end

  #     SubExtracter.new(mkdn, "HTML")
  #     SubExtractor.blocks
  #
  class SubExtractor < Extractor
    def initialize(content, type)
      @type  = type
      @lines = content.split("\n")
      super nil
      @regex = /^ {4}(.*?)$/
    end

    def blocks
      blocks = super
      blocks.select { |b|
        b.content =~ /^# #{@type}\s*(.*)$/m && b.content = $1
      }
    end
  end

  def lines
    @lines
  end
end
