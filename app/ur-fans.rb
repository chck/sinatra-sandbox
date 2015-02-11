require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require_relative 'models/follower'
require 'pry'

get '/' do
  Follower.create!(screen_name: 'chck', description: 'ohayounyugyo!')
  @followers = Follower.all
  # binding.pry
  erb :index
end
