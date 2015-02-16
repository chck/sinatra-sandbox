require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require_relative 'models/user'
require_relative 'services/desc-follower'
require 'pry'

class UrFans < Sinatra::Base
  get '/' do
    @users = User.all
    # binding.pry
    erb :index
  end

  post '/' do
    begin
      df = DescFollower.new
      df.insert_db(params[:screen_name])
      # User.create!(screen_name: params[:screen_name], description: 'ohayounyugyo!')
      p "success"
    rescue => e
      p e
      #@users = e.record
    end
    redirect '/'
    # erb :index
  end
end