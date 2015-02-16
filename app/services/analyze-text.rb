require 'natto'
require 'pry'

class AnalyzeText
  def initialize
    @exclude_txt_path = "../public/dic/stopword.txt"
    @exclude_words = get_exclude_words
    @mecab_option = "-u ../public/dic/custom.dic"
  end

  def get_exclude_words
    open(@exclude_txt_path,"r").readlines.map(&:chomp)
  end

  def keyword(text)
    t_map = {}
    @m = Natto::MeCab.new(@mecab_option)
    @m.parse(text) do |word|
      if word.feature.match("名詞") && !@exclude_words.include?(word.surface) 
        t_map[word.surface] = t_map[word.surface] ? t_map[word.surface] + 1 : 1
      end
    end
    t_map = t_map.sort_by {|k,v| v}

    #    t_map.each do |word, count|
    #      puts "#{word}\t\t#{count}"
    #    end
  end
end

#at = AnalyzeText.new
#text = open("./shortBocchan").read
#text = open("./texts.txt").read
#at.keyword(text)
