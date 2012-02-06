require './lib/ifdoc/version'

Gem::Specification.new do |s|
  s.name = "ifdoc"
  s.version = Ifdoc.version
  s.summary = %{SASS documentation tool.}
  s.description = %Q{Ifdoc generates documentation for your Sass/Compass projects.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://ricostacruz.com/ifkit"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }

  s.add_dependency "compass"
  s.add_dependency "haml"
  s.add_dependency "sass"
  s.add_dependency "redcarpet", ">= 2.0"
  s.add_dependency "nokogiri"
  s.add_dependency "tilt"
  s.add_dependency "fssm"
end
