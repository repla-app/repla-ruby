Gem::Specification.new do |s|
  s.name        = 'repla'
  s.version     = '0.3.0'
  s.date        = '2013-07-04'
  s.summary     = "Repla helper gem"
  s.description = "Bridge from Ruby to AppleScript to control Repla."
  s.authors = ["Roben Kleene"]
  s.email = 'contact@robenkleene.com'
  s.required_ruby_version = '~> 2.0'
  s.files = Dir.glob("lib/**/*").reject { |f| 
    f['lib/repla/repl/test'] ||
    f['lib/repla/dependencies/test'] 
  }
end