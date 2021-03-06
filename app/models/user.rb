require 'active_record'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||'sqlite3:db/development.db')
class User < ActiveRecord::Base
  has_many :follows, dependent: :destroy
end