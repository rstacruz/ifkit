namespace :doc do
  task :build do
    $:.unshift File.expand_path('../ifdoc/lib', __FILE__)

    require 'ifdoc'
    require 'yaml'

    s = Ifdoc::Project.new YAML::load_file('ifdoc.yml')
    s.build!

    puts "Wrote to output/index.html."
  end
end
