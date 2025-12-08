source "https://rubygems.org"

gem "rails", "~> 8.0.4"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# ============================================
# Authentication
# ============================================
gem "devise", "~> 4.9"

gem "bcrypt", "~> 3.1.7"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  # ============================================
  # RSpec - Test-Driven Development (TDD)
  # ============================================
  gem "rspec-rails", "~> 6.0.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 3.2"
  gem "shoulda-matchers", "~> 5.1"
  gem "csv"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  
  gem "simplecov", "~> 0.22.0"
  gem "simplecov-console"
end
