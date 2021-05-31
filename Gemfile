#!/usr/bin/ruby

source 'https://rubygems.org'
ruby "2.4.10"
gem 'rails', '4.2.8'
gem 'responders', '~> 2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '0.17.1'
gem "unicorn"
gem "girl_friday"
gem "exception_notification"
gem "kgio"
gem "raindrops"
gem "unf"

gem "sass-rails", '~>4.0.0'
gem "uglifier", '>=1.3.0'
# gem 'jquery-ui-rails'

gem "coffee-rails", '~>4.0.0'
gem "audited-activerecord", "4.0.0"
gem "acts_as_paranoid", "0.5.0"
gem "acts_as_tree", "1.6.1"
gem "uuid"

# gem 'jquery-rails'

#gem "rack", '= 1.2.2'   #Heroku seems to force this
gem 'dynamic_form'
gem "oauth"

gem "feed-normalizer"
gem "textacular"

gem "aws-s3", git: "https://github.com/bartoszkopinski/aws-s3.git"
gem "fog", '1.19.0'
gem 'xmlrpc'
gem "carrierwave"
gem "rmagick", '2.16.0'
gem "json", '~> 1.8.1'
gem "geokit-rails", "2.0.1"

gem "will_paginate"
gem "aasm", '3.0.19'
gem "authlogic", '3.5.0'
gem "scrypt"
#gem "authlogic-oid", :require => "authlogic_openid"
gem "ruby-openid", :require => "openid"
gem "open_id_authentication", :git => "git://github.com/rewritten/open_id_authentication.git"
gem "cancancan", "1.12.0"
gem "dalli"
gem "redcarpet"
gem 'syck'
gem 'rails_admin', '1.0.0'
gem 'safe_yaml'
gem "ar_after_transaction"
gem 'valid_email', :require => 'valid_email/email_validator'
gem "calendar_helper"
#gem "gibbon", :git => "git://github.com/amro/gibbon.git"
gem "bootstrap_form", "2.1.1"
gem 'test-unit'

group :development, :test do
  gem "heroku-api"
  gem "rack"
  gem "rack-test"
  gem "awesome_print"
  gem "artifice"
  gem "opentransact"
  gem 'annotate'
  gem 'therubyracer'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'highline'
  gem 'git'
end

group :production do
  gem 'memcachier'
  gem 'rails_12factor'
end

group :test do
  gem "capybara"
  gem "cucumber"
  gem "cucumber-rails"
  gem "database_cleaner"
  gem "guard-spork"
  gem "rspec-rails", "~> 2.13" # :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
  gem "spork"
end
gem 'remotipart'

