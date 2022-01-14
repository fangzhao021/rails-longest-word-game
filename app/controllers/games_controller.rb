require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
    @time_letters = Time.now()
  end

  def score
    @words = params[:word]
    @letters = params[:letters]
    @time_words = params[:time_words]
    if included?(@words, @letters)
      if english_word?(@words)
        score = @words.length / (@time_words - @time_letters)
        @message = "score: #{score} - Congratulations! \"#{@words}\" is a valid English word!"
      else
        @message = "Sorry but \"#{@words}\" does not seem to be a valid English word..."
      end
    else
      @message = "Sorry but \"#{@words}\" can't be built out of \"#{@letters.upcase}\""
    end
  end

private
  def included?(words, letters)
    words.chars.all? { |letter| words.count(letter) <= letters.count(letter) }
  end

  def english_word?(words)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{words}")
    json = JSON.parse(response.read)
    return json['found']
  end
end

# group :development, :test do
#   gem 'pry-byebug'
# end
