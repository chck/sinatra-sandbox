#require './analyze-text'
require_relative 'analyze-text'
require_relative 'desc-follower'
#require './desc-follower'

class AnalyzeFollower
  def initialize
    @fd = DescFollower.new
    @num = 0
    @fd.get_twitter_client(@num)
    @at = AnalyzeText.new
  end

  def get_fw_kw(twitter_id)
    #puts "-----GET FOLLOWER INFO-----"
    begin
      followers = @fd.get_followers(twitter_id)
    rescue => e
      p "#{e} sec"
      @fd.get_twitter_client(@num+=1)
      followers = @fd.get_followers(twitter_id)
    end
    texts = @fd.get_descriptions(followers).join
    #puts "-----ANALYZE KEYWORD-----"
    return @at.keyword(texts)
    #puts "-----END-----"
  end
end

# twitter_id = ARGV[0]
# af = AnalyzeFollower.new
# af.get_fw_kw(twitter_id).each do |k,v|
#   puts "#{k}\t\t\t#{v}"
# end
