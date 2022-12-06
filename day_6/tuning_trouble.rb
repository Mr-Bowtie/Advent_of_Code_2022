# No planning today, just speed!
# completed in 8:48.26 (not leaderboard worthy, but im still pleased)
require 'pry'
data_stream = File.read('data_stream.txt')

counter = 1
loop do
  packet = data_stream[(counter - 1), 14]
  break if packet.split('').uniq.length == 14

  counter += 1
end

# Counter marks the start of the packet
# the puzzle is looking for the total number of characters processed, so we want the location of the end of the packet
puts counter + 13
