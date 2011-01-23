source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.0.1'
gem 'jquery-rails'

gem "haml"
gem "bluecloth"
gem "responders"

gem "devise", ">= 1.1.1"
gem "devise_cas_authenticatable"
gem "cancan"

group :test, :development do
  gem "rspec-rails", ">= 2.0.0"
  gem "shoulda"
  gem "factory_girl_rails"
  gem "sqlite3-ruby", :require => 'sqlite3'
end

group :development do
  gem "thin"
  gem "yard"
  gem "rcov"
  gem "capistrano"
end

group :production do
  gem "mysql"
end
