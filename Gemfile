source "https://rubygems.org"
ruby '2.1.3'

gem 'sinatra'
gem 'activerecord'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'twitter'
gem 'natto'

group :development, :test do
  gem 'sqlite3'
  gem 'sinatra-reloader'
  gem 'foreman'
  gem 'pry'
  gem 'rake'
end

group :production do
  gem 'pg'
end