require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require_relative 'models/user'
require_relative 'services/analyze-follower'
require 'pry'

class UrFans < Sinatra::Base
  get '/' do
    @users = User.all
    # binding.pry
    erb :index
  end

  post '/' do
    begin
      # af = AnalyzeFollower.new
      # af.insert_db(params[:screen_name])
    rescue => e
      # p e
    end
    @user  = User.find_by(screen_name: params[:screen_name])
    @users = []
    erb :index
  end
end