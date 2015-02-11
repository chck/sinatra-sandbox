require File.dirname(__FILE__) + '/app/ur-fans'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run Sinatra::Application
