require 'active_record'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||'sqlite3:db/development.db')
class Follower < ActiveRecord::Base
end