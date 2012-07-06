$:.unshift File.expand_path('../ifdoc/lib', __FILE__)

namespace :doc do
  desc "Builds documentation in output/."

  task :build do
    gem 'sass', '> 3.1.9'
    require 'ifdoc'
    require 'yaml'

    print "Building output/index.html... "
    s = Ifdoc::Project.new YAML::load_file('ifdoc.yml')
    s.build!

    puts "OK."
  end

  desc "Rebuilds documentation as files change."
  task :watch do
    gem 'listen', '0.4.7'
    require 'listen'

    puts "Watching #{Dir.pwd}..."
    Listen.to Dir.pwd, ignore: %r[output] do |m, a, r|
      (m+a).each do |f|
        Rake.application.invoke_task :'doc:build'
      end
    end
  end

  desc "Deploys documentation to GitHub pages."
  task :deploy => :build do
    repo = ENV['to'] || 'rstacruz/ifkit'
    system "git-update-ghpages #{repo} -i output --force"
  end
end
