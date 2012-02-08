$:.unshift File.expand_path('../ifdoc/lib', __FILE__)

namespace :doc do
  task :build do
    require 'ifdoc'
    require 'yaml'

    s = Ifdoc::Project.new YAML::load_file('ifdoc.yml')
    s.build!

    puts "Wrote to output/index.html."
  end

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
end
