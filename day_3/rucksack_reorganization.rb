# frozen_string_literal: true

# INPUT:
#   - strings of letter characters, both upper and lower
#
# RULES:
#   - the input is split into groups of three lines
#   - each character is assigned a priority
#     a-z => 1-26
#     A-Z => 27-52
#
# OBJECTIVE:
#   - find the item shared among all three of each group (badge)
#   - sum the priorities of all the groups badges
#
# ALGO:
#   - split the file by \n
#   - create sub-arrays of size 3 in order; i.e. the first three strings is a group, the second three strings is a group, etc...
#   - for each group
#     - run an intersection on all three strings
#     - calc the priority of each badge
#   - sum the priorities

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
groups = []

while inventory.length > 0 
  groups.push inventory.shift(3)
end

badge_priority = groups.reduce(0) do |memo, group|
  elf_1, elf_2, elf_3 = group.map{|sack| sack.split("")}
  # intersection returns an array, need to pop out the single string value to pass to calc_priority
  badge = elf_1.intersection(elf_2, elf_3).pop
  memo + calc_priority(badge)
end

puts badge_priority
