source "https://rubygems.org"
ruby '2.1.3'

gem 'sinatra'
gem 'activerecord'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'

group :development, :test do
  gem 'sqlite3'
  gem 'sinatra-reloader'
  gem 'foreman'
  gem 'pry'
end

group :production do
  gem 'pg'
end