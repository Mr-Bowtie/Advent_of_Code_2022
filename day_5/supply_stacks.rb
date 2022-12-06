# frozen_string_literal: true

# input:
#  - an 9x9 grid of stacked letter chars (crates)
#    - 9 columns, 8 rows + 1 bottom row of ints 1-9 corresponding to the column number
#  - a list of crate movement instructions
#    - one instruction per line
#    - instruction format: 'move [count] from [stack_num] to [other_stack_num]'
#  - sections are separated by an empty line (\n\n)
#
# rules:
#  - crates are moved one at time, top down
#
# objective:
#  - determine which crate will end up on top of each stack
#
# algo:
#  - split input by blank line (\n\n) [to seperate the drawing from the instructions]
#  - convert drawing to hash of arrays : {column: array(crate_letters)}
#    - create drawing hash
#    - for each line
#      - split on every 4 chars,
#      - for each_with_index
#        - remove all whitespace
#        - next if empty
#        - strip brackets
#        - push drawing[index+1] += crate_char
#  - for each instruction
#    - extract count, from_stack, to_stack
#    - remove last [count] from stacks[from_stack], set in_flight_crates
#    - reverse in_flight_crates
#    - append to stacks[to_stack]
#  - extract and join last value from each stack
require('pry')

def extract_values(instruction)
  instruction.split(' ').each_with_object([]) do |word, memo|
    # there will never be a 0 value for count or stack column
    # ignore actual words, only care about numbers!
    next if word.to_i.zero?

    memo.push(word.to_i)
  end
end

def top_crates(crate_grid)
  crate_grid.values.each_with_object([]) do |crates, tops|
    tops.push(crates.last)
  end
end

stacks = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [] }

drawing, instructions = File.read('procedure.txt').split("\n\n")
drawing.split("\n").each do |row|
  stack_slots = row.scan(/\S{3}|\s{4}/)
  stack_slots.each_with_index do |crate, idx|
    # check for empty slot
    next if crate.match?(/\s{4}/)

    crate_sigil = crate.match(/\w/).to_s
    stacks[idx + 1].unshift(crate_sigil)
  end
end

instructions.split("\n").each do |inst|
  count, from_stack, to_stack = extract_values(inst)
  in_flight_crates = stacks[from_stack].pop(count).reverse
  stacks[to_stack] += in_flight_crates
end

puts top_crates(stacks).join('')
