require 'natto'
require 'twitter'
require 'yaml'
require_relative '../models/follow'
require_relative '../models/user'

class AnalyzeFollower
  def initialize
    @EXCLUDE_WORDS = open("./dic/stopword.txt").readlines.map(&:chomp)
    @EXCLUDE_REGEX = /[\d+\.\,\/:\(\);\[\]０-９]|^[\w|ぁ-ん|ァ-ヶ]$/
    @mecab         = Natto::MeCab.new("-u ,/dic/custom.dic")
    @YAML_PATH     = "./config/config.yml"
  end

  def get_twitter_client(num=0)
    conf    = YAML::load_file(@YAML_PATH)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = conf["tw_consumer_key#{num}"]
      config.consumer_secret     = conf["tw_consumer_secret#{num}"]
      config.access_token        = conf["tw_access_token#{num}"]
      config.access_token_secret = conf["tw_access_token_secret#{num}"]
    end
    @client
  end

  #REST::Client#follower_ids...5000ids/api
  #REST::Client#users...100ids/api(limit: x180/15min)
  def get_followers(twitter_id)
    token_num = 0
    followers = []
    get_twitter_client(token_num)
    target_user = @client.user(twitter_id)
    begin
      follower_ids = @client.follower_ids(twitter_id).to_a ##follower
      # follower_ids = @client.friend_ids(twitter_id).to_a   ##follow
      loop_count   = (follower_ids.size - 1) / 100 + 1
      loop_count.times do
        ids_temp      = follower_ids.pop(100) #末尾100アカウントを毎回削って使用
        accounts_temp = @client.users(ids_temp)
        followers << accounts_temp
      end
      followers.flatten!.each.with_index(1) { |fwer, i| puts "#{i}: #{fwer.screen_name}" }
    rescue Twitter::Error::TooManyRequests => error
      sec = error.rate_limit.reset_in
      p "wait #{sec}"
      p "No.#{token_num}"
      if token_num > 51
        token_num = 0
      else
        token_num += 1
      end
      get_twitter_client(token_num)
      retry
    ensure
      return target_user, followers.flatten
    end
  end

  def insert_db(twitter_id)
    gf          = get_followers(twitter_id)
    target_user = gf[0]
    User.create(id: target_user.id, screen_name: target_user.screen_name, description: target_user.description)

    followers = gf[1]
    followers.each do |fwer|
      fwer = User.create(id: fwer.id, screen_name: fwer.screen_name, description: fwer.description)
      Follow.create(follower_id: fwer.id, followee_id: followee.id)
    end
  end

  #頻出語抽出
  def get_freq_words(text)
    word_h = {}
    @mecab.parse(text) do |word|
      surface = word.surface
      next if surface =~ @EXCLUDE_REGEX
      next unless word.feature.match("名詞")
      word_h[surface] ? word_h[surface] += 1 : word_h[surface] = 1
    end
    return word_h.sort_by { |word, count| count }
  end

  def get_fwer_kw(twitter_id)
    puts "-----GET FOLLOWER INFO-----"
    followers = get_followers(twitter_id)
    puts "-----GET FOLLOWER DESCRIPTION-----"
    profile_texts = followers.map { |fwer| fwer.description }.join
    puts "-----ANALYZE FREQ WORDS-----"
    return get_freq_words(profile_texts)
  end
end

# twitter_id = ARGV[0]
# af = AnalyzeFollower.new
# af.get_fwer_kw(twitter_id).each do |k,v|
#   puts "#{k}\t\t\t#{v}"
# end
