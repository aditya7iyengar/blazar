source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'coveralls', '~> 0.8.23', require: false
  gem 'factory_bot_rails', '~> 5.0.2'
  gem 'simplecov', '~> 0.16.1', require: false
end

group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rake', '~> 12.3'
  gem 'rspec', '~> 3.0'
  gem 'rspec-rails', '~> 3.8'
  gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'bundler-audit', '~> 0.6.1'
  gem 'guard-rspec', '~> 4.7'
  gem 'rubocop', '~> 0.72.0'
  gem 'rubocop-git',
      git: 'git@github.com:stewartpark/rubocop-git.git',
      branch: 'invisible-offenses'
  gem 'sorbet', '~> 0.4'
  gem 'yard', '~> 0.9.20'
end

platforms :jruby do
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jruby-openssl'
end

platforms :ruby do
  gem 'sqlite3'
end
