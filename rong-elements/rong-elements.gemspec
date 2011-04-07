version = '0.2.1'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'rong-elements'
  s.version     = version
  s.summary     = 'Ruby-based Pong server implementation'
  s.description = 'Rong-elements contains shared game models and utilities for Rong, a Ruby implementation of Pong that consists of a server module for managing games, a client module for for interfacing with the server, and hopefully a few client implementations for playing some rad Pong, brah.'

  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.7"

  s.files = Dir['lib/**/*']

  s.author            = 'Matt Yoho'
  s.email             = 'mby@mattyoho.com'
  s.homepage          = 'http://github.com/mattyoho/rong'

  s.add_development_dependency('rspec', '~> 2.5.0')
end
