# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'blazar/version'

def add_platform_and_deps(spec)
  # This needs SQLite for now. Eventually use adapter pattern to make it
  # optional and support different Hosts
  # SQLite3 doesn't work for jruby
  spec.platform = Gem::Platform::RUBY
  spec.add_dependency 'sqlite3', '~> 1.4.2'

  spec.add_dependency 'rails', '~> 6.0.0'
end

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'blazar'
  spec.version     = Blazar::VERSION
  spec.authors     = ['Adi Iyengar']
  spec.email       = ['aditya7iyengar@gmail.com']
  spec.homepage    = 'https://adiiyengar.com'
  spec.summary     = 'Summary of Blazar.'
  spec.description = 'Description of Blazar.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  add_platform_and_deps(spec)
end
