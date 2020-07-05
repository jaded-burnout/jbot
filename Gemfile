# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby "2.7.1"

gem "ancestry"
gem "bcrypt", "~> 3.1.7" # Use ActiveModel has_secure_password
gem "bootsnap", ">= 1.1.0", require: false
gem "discordrb"
gem "generic_form_builder"
gem "jwt"
gem "oauth2"
gem "pg", ">= 0.18", "< 2.0" # Use postgresql as the database for Active Record
gem "puma", "~> 3.11" # Use Puma as the app server
gem "rails", "~> 5.2.2"
gem "sass-rails", "~> 5.0" # Use SCSS for stylesheets
gem "something_awful", path: "../something_awful"
gem "uglifier", ">= 1.3.0" # Use Uglifier as compressor for JavaScript assets
gem "warning"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "annotate"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "climate_control"
  gem "factory_bot"
  gem "rspec"
  gem "timecop"
end
