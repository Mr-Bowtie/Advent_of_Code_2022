require 'rspec'
require_relative '../crt_tv'

# INPUT:
#   - list of cpu commands, in two forms:
#     - addx <num> : after 2 cycles, add <num> to register X
#     - noop : do nothing for 1 cycle
#
# RULES:
#   - cpu is driven by a clock circuit, each tick is 1 cycle
#   - register X starts with value 1
#   - reg_x siginifies the location of the center of a sprit 3 pixels wide on a row 40 pixels wide
#   - crt draws 1 pixel each cycle
#   - if any of the sprites pixels overlapp with where the crt is currently drawing, the pixel will show (#), otherwise it's blank (.)
#   - the crt has a resolution of 40x6
#   - the crt draws one row at a time left to right
#   - sprite starts at the bottom right, (position 1)
#
# OBJECTIVE:
#   - recreate what the CRT displays after completing the full instruction list
#   - determine what 8 letters are displayed on the screen
#
# ALGO:
#   - create crt_row string
#   - create display array
#   - for each cycle
#     - determine sprite position
#     - append # or . to crt_row if sprite_position.cover?(cycle_counter)
#     - if crt_row.length == 40
#       - display.push(crt_row.dup)
#       - crt_row = ''
#

RSpec.describe ClockCircuit do
  let(:circuit) { described_class.new }

  before(:each) do
    circuit.cpu_commands = circuit.demo_commands
  end

  describe '#increment_cycle_counter' do
    it 'increments cycle counter' do
      circuit.increment_cycle_counter
      expect(circuit.cycle_counter).to eql(1)
    end

    it 'saves signal_strength on important cycles' do
      circuit.reg_x = 55
      circuit.cycle_counter = [20, 60, 100, 140, 180, 220].sample - 1
      circuit.increment_cycle_counter
      signal_strength = circuit.reg_x * circuit.cycle_counter
      expect(circuit.important_signals).to include(signal_strength)
    end

    it 'does not save signal_strength on non-important cycles' do
      circuit.cycle_counter = [*1..19].sample
      circuit.increment_cycle_counter
      expect(circuit.important_signals).to eql([])
    end
  end

  describe '#execute_commands' do
    it 'saves the correct values' do
      circuit.execute_commands
      expect(circuit.important_signals).to eql([420, 1140, 1800, 2940, 2880, 3960])
    end

    it 'gives the correct signal strength sum' do
      circuit.execute_commands
      expect(circuit.sum_sig_strengths).to eql(13_140)
    end
  end

  describe 'display' do
    it 'creates the correct display' do
      input = '##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....'
      circuit.execute_commands
      expect(circuit.display.join("\n")).to eql(input)
    end
  end
end
