# split the input by blank line
# sum each elf's calories
# return the highest number

calories = File.read('input.txt').split("\n\n")
most_prepared_elf = calories.reduce(0) do |memo, cals|
  cal_total = cals.split("\n").reduce(0) { |sum, cal| sum + cal.to_i }
  memo > cal_total ? memo : cal_total
end

p most_prepared_elf
