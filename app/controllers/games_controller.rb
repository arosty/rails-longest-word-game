require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @letters = params[:letters].split("")
    @word = params[:word]
    if check_letters
      if check_english
        @message = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @message = "Sorry but #{@word.upcase} does not seem to be a valid English word."
      end
    else
      @message = "Sorry but #{@word.upcase} can't be built out of #{@letters}."
    end
  end

  private

  def check_letters
    counter = Hash.new(0)
    @letters.each { |letter| counter[letter] += 1 }
    @word.upcase.split("").each do |letter|
      counter[letter] -= 1
      return false if counter[letter].negative?
    end
    return true
  end

  def check_english
    word_api = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@word}").read)
    return word_api["found"]
  end
end
