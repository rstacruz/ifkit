require 'fileutils'
require 'tilt'
require 'sass'
require 'compass'

module Ifdoc
  # Yay a project.
  #
  #     project.root
  #     project.blocks        # Array of Block
  #     project.html          # Final output!
  #
  #     project.css           # All CSS
  #     project.example_css   # CSS from all examples
  #
  class Project
    attr_reader :files

    def initialize(config)
      @config = Config.new(config)
      @config.validate!

      @files = @config.sources.map { |path| Dir[path] }.flatten.compact.uniq
    end

    def root
      Dir.pwd
    end

    def name
      blocks.first.name
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
      Tilt.new(@config.html).render(self, {
        :css => css,
        :blocks => blocks,
        :project => self
      })
    end

    def example_css
      blocks.map { |b| b.example_css }.join "\n"
    end

    def css
      Tilt.new(css_format, css_options) { sass }.render.
        gsub(/(\/\*.*?\*\/\s*)/m, '').
        gsub(/\n{2,}/m, "\n")
    end

    # scss or sass?
    def css_format
      File.extname(@config.css)[1..-1]
    end

    def html_format
      File.extname(@config.html)[1..-1]
    end

    def css_options
      opts = Compass.sass_engine_options
      paths = Array.new
      paths += @config.sass.load_paths  if @config.sass? && @config.sass.load_paths?
      paths += [Ifdoc.root('data', 'sass')]
      paths += opts[:load_paths]

      { :load_paths => paths, :style => :compact }
    end

    # Sass source
    def sass
      [ css_header, example_css ].join("\n")
    end

    # The CSS header based on the given css file
    def css_header
      File.read(@config.css)
    end

    def build!
      FileUtils.mkdir_p output_path
      File.open(output_path('index.html'), 'w') { |f| f.write html }
    end

  private
    def output_path(*a)
      File.join @config.output_path, *a
    end
  end
end

