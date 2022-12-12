require 'pry'
class Monkey
  attr_accessor :number, :items, :operation, :test_divisor, :true_monkey, :false_monkey, :inspection_count, :lcm, :current_item

  def initialize(number: nil, test_divisor: nil, true_monkey: nil, false_monkey: nil, starting_items: [], operation: '')
    @number = nil
    @items = []
    @operation = nil
    @test_divisor = nil
    @true_monkey = nil
    @false_monkey = nil
    @inspection_count = 0
    @current_item = nil
    @lcm = nil
  end

  def calc_worry_level(item)
    self.current_item = operation.call(item)
    self.current_item = current_item % lcm
  end

  def pass_test?(item)
    (calc_worry_level(item) % test_divisor).zero?
  end

  def throw_item(item)
    pass_test?(item) ? true_monkey.items.push(current_item) : false_monkey.items.push(current_item)
  end

  def process_item
    item = items.shift
    self.inspection_count += 1
    throw_item(item)
  end

  def play_turn
    process_item until items.empty?
  end
end

class MonKeepAway
  attr_accessor :stats, :monkeys, :divisors

  def initialize
    @stats = File.read('monkey_stats.txt').split("\n\n")
    @monkeys = make_monkeys
    @divisors = []
    stat_monkeys
  end

  def make_monkeys
    monkey_hash = {}
    8.times do |i|
      monkey_hash[i] = Monkey.new
    end
    monkey_hash
  end

  def stat_monkeys
    stats.each do |monkey_stats|
      setup_monkey(monkey_stats.split("\n"))
    end
    lcm = calc_lcm
    monkeys.each {|_, monkey| monkey.lcm = lcm}
  end

  def calc_lcm
    divisors.reduce(&:*)
  end

  def setup_monkey(stats)
    number = extract_number(stats[0])
    monkey = monkeys[number]
    monkey.number = number
    monkey.items = extract_items(stats[1])
    monkey.operation = extract_operation(stats[2])
    divisor = extract_number(stats[3])
    divisors.push(divisor)
    monkey.test_divisor = divisor
    monkey.true_monkey = monkeys[extract_number(stats[4])]
    monkey.false_monkey = monkeys[extract_number(stats[5])]
  end

  def play_round
    monkeys.each do |_num, monkey|
      monkey.play_turn
    end
  end

  def calc_most_active_monkeys
    counts = monkeys.map { |_, monkey| monkey.inspection_count }
    counts.sort.slice(-2..).reduce(&:*)
  end

  # match the number
  def extract_number(line)
    line.match(/\d+/).to_s.to_i
  end

  # split on " ", filter out non-numbers
  def extract_items(line)
    line = line.gsub(',', '')
    nums = line.split(' ').filter { |chars| chars.to_i.to_s == chars }
    nums.map(&:to_i)
  end

  # split on ':'
  # delete 'operation'
  # split on '=', keep second half
  # build lambda out of second half
  def extract_operation(line)
    operation = line.split(':')[1]
    operation = operation.split('=')[1]
    eval "lambda {|old| #{operation}}"
  end
end

game = MonKeepAway.new
10_000.times { game.play_round }
puts game.calc_most_active_monkeys
