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
#   - signal strength is calculated: cycle_num * reg_x
#
# OBJECTIVE:
#   - calculate the signal strength at cycles: 20, 60, 100, 140, 180, 220
#   - sum these signal strength together.
#
# ALGO:
#   - create register X with value 1
#   - start cycle_counter with value 0
#   - create list of important_cycles
#   - For each command
#       - push register value to important_values
#     - case command
#     - when noop
#       - increment_cycle_counter
#       - next
#     - when addx
#       - 2.times do
#         - increment_cycle_counter
#       - reg_x += <val>
#   - increment_cycle_counter
#     - check if current_cycle is in important_cycles
#       - push register value to important_values
#     - cycle_counter += 1

RSpec.describe ClockCircuit do
  let(:circuit) { described_class.new }

  before do
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
      expect(circuit.sum_sig_strengths).to eql(13140)
    end
  end
end
