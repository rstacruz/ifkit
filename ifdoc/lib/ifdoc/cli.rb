require 'ifdoc'

module Params
  def extract(what)
    i = index(what) and slice!(i, 2)[1]
  end

  def first_is(what)
    shift  if first == what
  end

  def first_matches(what)
    shift  if first.downcase == what.downcase[0...first.size]
  end
end

ARGV.extend Params

module Ifdoc
  class CLI
    def err(str)
      $stderr.write "#{str}\n"
    end

    def project
      Project.new config
    end

    def config
      unless config_file
        err "No config file found."
        exit 256
      end

      YAML::load_file config_file
    end

    def config_file
      Dir['./ifdoc.yml'].first
    end

    def run!
      if ARGV.first_matches 'build'
        puts "Build?"
      end
    end
  end
end
