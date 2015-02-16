require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require_relative 'models/user'
require 'pry'

class UrFans < Sinatra::Base
  get '/' do
    @users = User.all
    # binding.pry
    erb :index
  end

  post '/' do
    begin
      User.create!(screen_name: params[:screen_name], description: 'ohayounyugyo!')
      p "success"
    rescue => e
      p e
      #@users = e.record
    end
    redirect '/'
    # erb :index
  end
end