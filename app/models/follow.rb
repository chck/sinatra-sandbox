require 'active_record'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||'sqlite3:db/development.db')
class Follow < ActiveRecord::Base
  belongs_to :user
end
