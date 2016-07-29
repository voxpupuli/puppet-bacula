source "https://rubygems.org"


group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.5.0'
  gem "puppet-lint"
  gem 'rspec'
  gem 'rspec-core'
  gem 'rspec-mocks'
  gem 'rspec-expectations'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "metadata-json-lint"
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper"
  gem "rspec-puppet-facts"
  gem 'json', '~>1.0' if RUBY_VERSION == '1.9.3'
  gem 'json_pure', '~>1.0' if RUBY_VERSION == '1.9.3'
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "puppet-blacksmith"
end
