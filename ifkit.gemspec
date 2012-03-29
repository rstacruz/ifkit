Gem::Specification.new do |s|
  s.name = "ifkit"
  s.version = "0.0.1.pre1"
  s.summary = %{Interface mixins.}
  s.description = %{Nice interface mixins for Sass.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["hi@ricostacruz.com"]
  s.homepage = "http://github.com/rstacruz/ifkit"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }
end
