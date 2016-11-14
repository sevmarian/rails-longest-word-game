require 'open-uri'
require 'json'

class WordController < ApplicationController

def game
  @grid = Array.new(10) { ('A'..'Z').to_a[rand(26)] }
end

def score
  @proposition = params[:proposition]
  @grid = params[:grid]
  translation = get_translation(@proposition)
if @proposition.upcase.split.all? { |letter| @proposition.count(letter) <= @grid.count(letter) } && translation != @proposition && translation != nil
    @result = [1, 'you win']
  else
    @result = [0, 'you lost']
end
end

def get_translation(word)
  api_key = "363e83de-77b3-46d6-bd24-cee19de72a3e"
  begin
    response = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api_key}&input=#{word}")
    json = JSON.parse(response.read.to_s)
    if json['outputs'] && json['outputs'][0] && json['outputs'][0]['output'] && json['outputs'][0]['output'] != word
      return json['outputs'][0]['output']
    end
  rescue
    if File.read('/usr/share/dict/words').upcase.split("\n").include? word.upcase
      return word
    else
      return nil
    end
  end

end
end
