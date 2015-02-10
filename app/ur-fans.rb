require 'sinatra/base'

class UrFans < Sinatra::Base
  get '/' do
    erb :index
  end
end