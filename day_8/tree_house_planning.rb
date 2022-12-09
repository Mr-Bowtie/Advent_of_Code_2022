# frozen_string_literal: true

# INPUT:
#   - a grid of integers
#   - each int represents the height of a tree in that position
#
# OBJECTIVE:
#   - count how many trees are visible from outside the grid
#
# RULES:
#   - all tree along the edges are considered visible
#   - a tree is visible if all other trees between it and an edge are shorter than it
#   - the grid is a square 99x99
#
# ALGO:
#   - split file by \n
#   - generate columns and rows hashes
#     - iterate over split line
#       - append each int(convert from string to int) to an array whose key is the ints position
#       - same but for row position
#   - for all rows
#     - for each int
#       - starting ints are all visible
#       - determine if any tree is taller from tree_start to end of the row
#       - reverse row, check again
#       - add position [row, col] of any visible trees to visible_trees array
#         - only add position if it's inverse doesnt already exists in the array ([0,1] [1,0])
#   - the same but for columns
#   - count the number of elements in visible_trees
#
require 'pry'
class TreeGrid
  attr_accessor :tree_grid, :rows, :columns, :visible_trees

  def initialize
    @tree_grid = File.read('tree_heights.txt').split("\n")
    @rows = {}
    @columns = {}
    build_grid
    @visible_trees = spot_tall_trees
  end

  def build_grid
    tree_grid.each_with_index do |row_line, row|
      row_line = row_line.split('')
      row_line.each_with_index do |tree, col|
        tree = tree.to_i
        rows[row].nil? ? rows[row] = [tree] : rows[row].push(tree)
        columns[col].nil? ? columns[col] = [tree] : columns[col].push(tree)
      end
    end
  end

  def spot_tall_trees
    tall_trees = []
    rows.each do |row_num, row_vals|
      tall_trees += spot_in_row(row_num, row_vals)
      tall_trees += spot_in_row(row_num, row_vals.reverse, true)
    end
    columns.each do |col_num, col_vals|
      tall_trees += spot_in_columns(col_num, col_vals)
      tall_trees += spot_in_columns(col_num, col_vals.reverse, true)
    end
    tall_trees.uniq
  end

  def spot_in_row(row_num, row_vals, reverse = false)
    talls = []
    row_vals.each_with_index do |tree, col_num|
      rev_col_num = 98 - col_num if reverse
      if col_num.zero? || col_num == 98
        talls.push([row_num, col_num])
        next
      end

      next if col_num == 98 || col_num.zero?

      # binding.pry if reverse && col_num == 90
      col_pos = reverse ? rev_col_num : col_num
      talls.push([row_num, col_pos]) if tree > row_vals[(col_num + 1)..].max
    end
    talls
  end

  def spot_in_columns(col_num, col_vals, reverse = false)
    talls = []
    col_vals.each_with_index do |tree, row_num|
      rev_row_num = 98 - row_num if reverse
      if row_num.zero? || row_num == 98
        talls.push([row_num, col_num])
        next
      end

      next if row_num == 98 || row_num.zero?

      row_pos = reverse ? rev_row_num : row_num
      talls.push([row_pos, col_num]) if tree > col_vals[(row_num + 1)..].max
    end
    talls
  end
end

tree_field = TreeGrid.new
puts tree_field.visible_trees.count
