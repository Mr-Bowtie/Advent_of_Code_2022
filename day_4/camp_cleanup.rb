# frozen_string_literal: true

# INPUT:
#   - file, each line is a pair of section assignments (ranges)
#
# RULES:
#   - each pair is two numbers seperated by a dash (-)
#   - the left side of the dash will always be lower than the right side
#   - the two assigmnent ranges are seperated by a comma
#
# OBJECTIVE:
#   - determine in how many assignment pairs there is any overlapping assignments
#
# ALGO:
#   - split file by \n
#   - reduce
#     - split line by comma
#     - for each side
#       - create a range with the two numbers
#       - check if the beginning or the end of the opposite range is within the current range.
#
require 'pry'

class Range
  def assignments_overlap?(range)
    self === range.begin || self === range.end
  end
end

assignments = File.read('section_assignments.txt').split("\n")
overlap_total = assignments.reduce(0) do |memo, ass|
  left_ass, right_ass = ass.split(',').map { |a| a.split('-') }
  left_range = Range.new(left_ass[0].to_i, left_ass[1].to_i)
  right_range = Range.new(right_ass[0].to_i, right_ass[1].to_i)
  if left_range.assignments_overlap?(right_range) || right_range.assignments_overlap?(left_range)
    memo + 1
  else
    memo
  end
end

puts overlap_total
