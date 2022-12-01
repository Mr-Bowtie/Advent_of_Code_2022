# split the input by blank line
# sum each elf's calories
# return the highest number

calories = File.read("input.txt").split("\n\n")
summed_cals = calories.map do |cal_str|
  cal_str.split("\n").reduce(0) { |sum, cals| sum + cals.to_i }
end

top_three_total = summed_cals.sort.pop(3).sum
p top_three_total
