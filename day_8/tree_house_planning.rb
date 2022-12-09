# INPUT:
#   - a grid of integers
#   - each int represents the height of a tree in that position
#
# OBJECTIVE:
#   - determine the highest scenic score for a single tree in the grid
#
# RULES:
#   - scenic score found by multiplying together the viewing distance in each of the four directions
#   - view distance in one direction is the number of trees between(and including) the current tree and either an edge or a tree of equal or greater height
#   - a tree on the edge has viewing distance of 0 in the direction of the edge
#   - the grid is a square 99x99
#
# ALGO:
#
#   - for each int
#     - find left/right viewing distance(rows)
#       - create two arrays
#         - tree_pos..
#         - (0...tree_pos).reverse
#       - each_with_index
#         - break if el >= tree
# =>      - return index + 1
#     - find up/down viewing distance(cols)
#     - determine scenic score
#
require 'pry'
require 'matrix'

class TreeGrid
  attr_accessor :tree_grid, :rows, :columns, :visible_trees, :most_scenic_tree, :tree_scores

  def initialize
    @tree_grid = File.read('tree_heights.txt').split("\n")
    @rows = {}
    @columns = {}
    build_grid
    @visible_trees = spot_tall_trees
    @tree_scores = {}
    @most_scenic_tree = calc_scenic_tree
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

  # returns viewing distances in one direction pair - [front, back] or [up, down]
  def determine_viewing_distance(tree_pos, sight_line_vals)
    # left or up
    return [0, 0] if tree_pos == 0

    tree = sight_line_vals[tree_pos]
    in_front = sight_line_vals[0...tree_pos].reverse
    behind = sight_line_vals[(tree_pos + 1)..]
    viewing_distances = []

    in_front.each_with_index do |distant_tree, idx|
      distance = idx + 1
      if distant_tree >= tree || distance == in_front.length
        viewing_distances.push(distance)
        break
      end
    end

    behind.each_with_index do |distant_tree, idx|
      distance = idx + 1
      next unless distant_tree >= tree || distance == behind.length

      viewing_distances.push(distance)
      break
    end
    viewing_distances
  end

  def calc_scenic_tree
    grid = Matrix.build(98) { |row, col| [row, col] }.to_a.flatten(1)
    grid.each do |row, col|
      # rows
      score_tally = determine_viewing_distance(col, rows[row])
      # columns
      score_tally += determine_viewing_distance(row, columns[col])

      tree_scores[[row, col]] = score_tally.reduce(&:*)
    end

    tree_scores.values.reduce(0) { |value, memo| value > memo ? memo = value : memo }
  end
end

tree_field = TreeGrid.new
puts tree_field.most_scenic_tree
