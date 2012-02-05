require 'fileutils'
require 'tilt'
require 'sass'
require 'compass'

module StyleDoc
  class Project
    attr_reader :files

    def initialize(config)
      @config = config
      @files = config['sources'].map { |path| Dir[path] }.flatten.compact
    end

    def root
      Dir.pwd
    end

    def comment_blocks
      @files.map { |fn|
        Extractor.new(fn).blocks
      }.flatten.compact
    end

    def blocks
      comment_blocks.map { |coblock|
        b = Block.new coblock
        b if b.valid?
      }.compact
    end

    def html
      Tilt.new(@config['html']).render(self, {
        :css => css,
        :blocks => blocks
      })
    end

    def src_css
      blocks.map { |b| b.src_css }.join("\n")
    end

    def css
      Tilt.new(css_format, css_options) { sass }.render
    end

    # scss or sass?
    def css_format
      File.extname(@config['css'])[1..-1]
    end

    def html_format
      File.extname(@config['html'])[1..-1]
    end

    def css_options
      opts = Compass.sass_engine_options
      paths = @config['sass']['load_paths']
      paths += opts[:load_paths]
      { :load_paths => paths }
    end

    # Sass source
    def sass
      [ css_header, src_css ].join("\n")
    end

    # The CSS header based on the given css file
    def css_header
      File.read(@config['css'])
    end

    def build!
      FileUtils.mkdir_p output_path
      File.open(output_path('index.html'), 'w') { |f| f.write html }
    end

  private
    def output_path(*a)
      File.join @config['output_path'], *a
    end
  end
end

