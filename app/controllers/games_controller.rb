require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @letters = params[:letters].split
    @guess = params[:guess]
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    if word_exists?(url) && word_in_grid_ok?(@guess, @letters)
      @result = "#{@guess} is a word 🎃"
    else
      @result = !word_exists?(url) ? "not an english word" : "Word not in the grid"
    end
  end

  private

  def word_exists?(url)
    open(url) do |data|
      result = JSON.parse(data.read)
      result['found']
    end
  end

  def word_in_grid_ok?(attempt, grid)
    attempt.upcase.chars.all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
  end
end
