require 'pry'
class ClockCircuit
  attr_accessor :cpu_commands,
                :cycle_counter,
                :reg_x,
                :demo_commands,
                :important_cycles,
                :important_signals,
                :crt_row,
                :display

  @@important_cycles = [20, 60, 100, 140, 180, 220]
  def initialize
    @demo_commands = File.read('./cpu_instructions_demo.txt').split("\n")
    @cpu_commands = File.read('./cpu_instructions.txt').split("\n")
    @cycle_counter = 0
    @reg_x = 1
    @important_signals = []
    @crt_row = ''
    @display = []
  end

  def increment_cycle_counter
    row_builder
    row_push_and_reset if crt_row.length == 40
    self.cycle_counter += 1
    important_signals.push(signal_strength) if @@important_cycles.include?(cycle_counter)
  end

  def row_builder
    char = sprite_overlap_draw? ? '#' : '.'
    self.crt_row += char
  end

  def row_push_and_reset
    display.push(crt_row.dup)
    self.crt_row = ''
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
        2.times do |i| 
          i = i + 1 
          increment_cycle_counter
        end
        self.reg_x += value.to_i
      end
    end
  end

  def sum_sig_strengths
    important_signals.sum
  end

  def sprite_overlap_draw?
    sprite_position.cover?(cycle_counter % 40)
  end

  def sprite_position
    ((reg_x - 1)..(reg_x + 1))
  end
end

crt_tv = ClockCircuit.new
crt_tv.execute_commands
puts crt_tv.display
