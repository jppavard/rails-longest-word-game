require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
    session[:grid] = @letters.join
  end

  def score
    if word_present_in_grid?
      request_api
    else
      @score = "Sorry but <strong>#{params[:word]}</strong> can't be built out of #{session[:grid]}"
    end
  end

  private

  def generate_grid(grid_size)
    grid = []
    grid_size.times { grid << ('A'..'Z').to_a.sample }
    return grid
  end

  def word_present_in_grid?
    grid = session[:grid].downcase
    result = true

    params[:word].split('').each do |letter|
      if grid.include? letter
        grid.delete(letter)
      else
        result = false
      end
    end
    result
  end

  def request_api
    api_response = open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    result = JSON.parse(api_response)
      if result['found'] == true
        @score = "Congratulation! <strong>#{params[:word]}</strong> is a valid english word"
      else
        @score = "Sorry but <strong>#{params[:word]}</strong> doesn't seem to be an english word"
      end
  end
end
