# frozen_string_literal: true

# column 1 = opponents move [A,B,C]
#   A = rock
#   B = paper
#   C = scissors
#
# column 2 = winning response [X,Y,Z]
#   X = rock
#   Y = paper
#   Z = scissors
#
# round scoring = selection + outcome
#
# selection
#   rock = 1
#   paper = 2
#   scissors = 3
#
# outcome
#   loss = 0
#   draw = 3
#   win = 6
#
# input example:
#   A Y
#   B X
#   C Z
#
# Objective: calculate total score if you follow the strategy guide
#
# Algo:
#   - split input by newline (sanitize, remove whitespace if necessary)
#   - reduce
#     - assign first letter to opponents_move, second to players_move
#     - determine outcome
#     - calc score; selection_score + outcome_score
#     - add score to memo

require 'pry'

OUTCOME_SCORE_TABLE = {
  'A X' => 3,
  'A Y' => 6,
  'A Z' => 0,
  'B X' => 0,
  'B Y' => 3,
  'B Z' => 6,
  'C X' => 6,
  'C Y' => 0,
  'C Z' => 3
}.freeze

PLAY_SCORE = {
  'X' => 1, 
  'Y' => 2, 
  'Z' => 3
}

guide = File.read('strategy_guide.txt').split("\n")
total_score = guide.reduce(0) do |memo, round|
  players_move = round.slice(-1, 1)
  round_score = PLAY_SCORE[players_move] + OUTCOME_SCORE_TABLE[round]
  memo + round_score
end

puts total_score
