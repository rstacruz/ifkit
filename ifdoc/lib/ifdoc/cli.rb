require 'ifdoc'
require 'yaml'

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
      @project = Project.new config
    end

    def project!
      @project = nil; project
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

    def watch!
      require 'fssm'

      puts "Watching."
      cli = self
      FSSM.monitor(Dir.pwd, '**/*') do
        update { |base, f|
          unless f.include?('output')
            print "Updating... "
            cli.project!.build!
            puts "Done."
          end
        }
      end
    end

    def run!
      if ARGV.empty?
        puts "help"
      elsif ARGV.first_matches 'watch'
        watch!
      elsif ARGV.first_matches 'build'
        project
        puts "Building..."
        project.build!
        puts "Done. Wrote to #{config['output_path']}."
      end
    end
  end
end
