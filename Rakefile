$:.unshift File.expand_path('../ifdoc/lib', __FILE__)

namespace :doc do
  desc "Builds documentation in output/."

  task :build do
    require 'ifdoc'
    require 'yaml'

    s = Ifdoc::Project.new YAML::load_file('ifdoc.yml')
    s.build!

    puts "Wrote to output/index.html."
  end

  desc "Rebuilds documentation as files change."
  task :watch do
    require 'fssm'

    puts "Watching #{Dir.pwd}..."
    FSSM.monitor(Dir.pwd, '**/*') do
      update { |base, f|
        unless f.include?('output')
          puts "Building..."
          system "rake doc:build"
        end
      }
    end
  end

  desc "Deploys documentation to GitHub pages."
  task :deploy => :build do
    repo = ENV['to'] || 'rstacruz/ifkit'
    system "git-update-ghpages #{repo} -i output"
  end
end
