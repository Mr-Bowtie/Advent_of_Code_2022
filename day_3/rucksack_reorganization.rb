# frozen_string_literal: true

# INPUT:
#   - strings of letter characters, both upper and lower
#
# RULES:
#   - every string is even
#   - each half contains exactly onecharacter shared with the other half (missplaced item)
#   - each character is assigned a priority
#     a-z => 1-26
#     A-Z => 27-52
#
# OBJECTIVE:
#   - find the sum of the priority of all the missplaced items
#
# ALGO:
#   - split the file by \n
#   - reduce
#     - split string into array of chars
#     - cmp_1 = first half; cmp_2 = second half
#     - run array intersection to find missplaced item
#     - memo + item priority

require 'pry'

LOWERCASE = ('a'..'z').to_a
UPPERCASE = ('A'..'Z').to_a 

def calc_priority(char)
  if LOWERCASE.include?(char)
    LOWERCASE.index(char) + 1
  else
    UPPERCASE.index(char) + 27
  end
end

inventory = File.read('inventory.txt').split("\n")
total_priority = inventory.reduce(0) do |memo, sack|
  sack_arr = sack.split('')
  half = sack_arr.length / 2
  cmp_1 = sack_arr.slice(0, half)
  cmp_2 = sack_arr.slice(half, half)
  missplaced_item = cmp_1.intersection(cmp_2).pop
  memo + calc_priority(missplaced_item)
end

puts total_priority

