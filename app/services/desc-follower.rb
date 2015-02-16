require 'twitter'
require 'yaml'
require 'pry'
require 'active_record'
require_relative '../models/user'
require_relative '../models/follow'

class DescFollower
  #initializeにしない理由がある。スレッドセーフ的な
  def get_twitter_client(num)
    conf    = YAML::load_file(File.join("#{__dir__}/../../config", "config.yml"))
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = conf["tw_consumer_key#{num}"]
      config.consumer_secret     = conf["tw_consumer_secret#{num}"]
      config.access_token        = conf["tw_access_token#{num}"]
      config.access_token_secret = conf["tw_access_token_secret#{num}"]
    end
    @client
  end

  def get_followers(twitter_id)
    users = []
    num   = 0
    get_twitter_client(num)
    target_user_id = @client.user(twitter_id)
    begin
      follower_ids = @client.follower_ids(twitter_id).to_a
      loop_count   = (follower_ids.size - 1) / 100 + 1
      loop_count.times do
        ids_temp      = follower_ids.pop(100) #末尾100アカウントを毎回取って使用
        accounts_temp = @client.users(ids_temp)
        users << accounts_temp
      end
    rescue Twitter::Error::TooManyRequests => error
      sec = error.rate_limit.reset_in
      puts "wait #{sec} sec"
      # raise "#{sec}"
      #  sleep(sec) #規制解除までの秒数
      get_twitter_client(num+=1)
      puts "retry: #{num}"
      retry
    ensure
      return target_user_id, users.flatten
    end
  end

  def insert_db(twitter_id)
    gf          = get_followers(twitter_id)
    followee_id = gf[0].id
    followers   = gf[1]
    followers.each do |follower|
      follower = User.create!(id: follower.id, screen_name: follower.screen_name, description: follower.description)
      Follow.create!(follower_id: follower.id, followee_id: followee_id)
    end
  end
end

#fd = DescFollower.new
#twitter_id = "paranoia_c"
#fd.get_twitter_client
#followers = fd.get_followers(twitter_id)
#puts fd.get_descriptions(followers)
