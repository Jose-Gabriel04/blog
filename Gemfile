# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.3'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'byebug', '~> 11.1', '>= 11.1.3'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'faker', '~> 3.5', '>= 3.5.2'
  gem 'fasterer', '~> 0.11.0'
  gem 'html2haml', '~> 2.3'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.2'
end

group :development do
  gem 'rubocop', '~> 1.64', '>= 1.64.1', require: false
  gem 'rubocop-factory_bot', '~> 2.26', '>= 2.26.1', require: false
  gem 'rubocop-performance', '~> 1.21', require: false
  gem 'rubocop-rails', '~> 2.25', require: false
  gem 'rubocop-rspec', '~> 3.0', '>= 3.0.1', require: false
  gem 'rubocop-rspec_rails', '~> 2.30', require: false
  gem 'web-console'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.2'
  gem 'fuubar', '~> 2.5', '>= 2.5.1'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'shoulda-matchers'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov-console', '~> 0.9.4', require: false
end
