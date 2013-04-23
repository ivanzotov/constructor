# encoding: utf-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{constructor-cap}
  s.version           = '0.1'
  s.summary           = %q{Cap for Constructor}
  s.authors           = ['Ivan Zotov']
  s.require_paths     = %w(lib)
  
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  
  s.add_dependency 'haml-rails'
end