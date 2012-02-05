namespace :doc do
  task :build do
    require './styledoc/styledoc'
    require 'yaml'

    s = StyleDoc::Project.new YAML::load_file('styledoc.yml')
    s.build!

    puts "Wrote to output/index.html."
  end
end
