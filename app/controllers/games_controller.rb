require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def ask
    @grid = Array.new(9) { ('A'..'Z').to_a.sample }.join(" ")
    @start_time = Time.now
  end

  def result
    end_time = Time.now
    attempt = params[:prop]
    start_time = Time.parse(params[:start_time])
    grid = params[:grid].split(" ")
    @resultat = { time: end_time - start_time }
    byebug
    score = score_and_message(attempt, grid, @resultat[:time])
    @resultat[:score] = score.first
    @resultat[:message] = score.last
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end



