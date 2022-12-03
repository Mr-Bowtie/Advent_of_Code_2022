# frozen_string_literal: true

# ================ FIRST PUZZLE ====================
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
#
# ===================== SECOND PUZZLE =================
#
# only change is that column 2 is how the round needs to end
#   X = lose
#   Y = draw
#   Z = win
require 'pry'

OUTCOME_SCORE_TABLE = {
  'X' => 0,
  'Y' => 3,
  'Z' => 6
}.freeze

PLAY_SCORE = {
  'rock' => 1,
  'paper' => 2,
  'scissors' => 3
}.freeze

CORRECT_RESPONSE = {
  'A X' => 'scissors',
  'A Y' => 'rock',
  'A Z' => 'paper',
  'B X' => 'rock',
  'B Y' => 'paper',
  'B Z' => 'scissors',
  'C X' => 'paper',
  'C Y' => 'scissors',
  'C Z' => 'rock'
}.freeze

guide = File.read('strategy_guide.txt').split("\n")
total_score = guide.reduce(0) do |memo, round|
  players_move = CORRECT_RESPONSE[round]
  outcome = round.slice(-1, 1)
  round_score = PLAY_SCORE[players_move] + OUTCOME_SCORE_TABLE[outcome]
  memo + round_score
end

puts total_score
