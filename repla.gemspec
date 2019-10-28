Gem::Specification.new do |s|
  s.name        = 'repla'
  s.version     = '0.10.0'
  s.date        = '2013-07-04'
  s.summary     = 'Repla helper gem'
  s.description = 'Bridge from Ruby to AppleScript to control Repla.'
  s.authors = ['Roben Kleene']
  s.email = 'contact@robenkleene.com'
  s.files = Dir.glob('lib/**/*').reject do |f|
    f['lib/repla/repl/test'] ||
      f['lib/repla/dependencies/test']
  end
end
