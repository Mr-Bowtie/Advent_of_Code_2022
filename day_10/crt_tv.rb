require 'pry'
class ClockCircuit
  attr_accessor :cpu_commands, :cycle_counter, :reg_x, :demo_commands, :important_cycles, :important_signals

  @@important_cycles = [20, 60, 100, 140, 180, 220]
  def initialize
    @demo_commands = File.read('./cpu_instructions_demo.txt').split("\n")
    @cpu_commands = File.read('./cpu_instructions.txt').split("\n")
    @cycle_counter = 0
    @reg_x = 1
    @important_signals = []
  end

  def increment_cycle_counter
    # binding.pry if cycle_counter == 219
    self.cycle_counter += 1
    important_signals.push(signal_strength) if @@important_cycles.include?(cycle_counter)
  end

  def signal_strength
    reg_x * cycle_counter
  end

  def execute_commands
    cpu_commands.each do |command|
      action, value = command.split(' ')
      case action 
      when 'noop'
        increment_cycle_counter
      when 'addx'
        2.times {increment_cycle_counter}
        self.reg_x += value.to_i
      end
    end
  end

  def sum_sig_strengths 
    important_signals.sum
  end
end

crt_tv = ClockCircuit.new
crt_tv.execute_commands
puts crt_tv.sum_sig_strengths
