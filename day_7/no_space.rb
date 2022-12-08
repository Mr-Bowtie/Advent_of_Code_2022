# INPUT:
#   - terminal commands and output
#     - commands and output values are all on seperate lines
#   - lines starting with $ are commands
#   - without $ are output
#
# RULES:
#   - commands can be:
#     - cd
#       - <dir_name>: look in current dir for dir with dir_name and make current_dir
#       - ..: move out one level
#       - /: move to the outermost dir
#     - ls: list out all files and directories in dir
#       - 1234 abc: current_dir contains file abc of size 1234
#       - dir xyz: current_dir contains dir xyz
#   - Size of directory = sum of files contained directly or indirectly (nested in other dirs)
#
# OBJECTIVE:
#   - find all directories with total size max of 100000
#   - sum the total sizes or all those directories
#
# ALGO:
#   - split input by \n
#   - process steps in order to build directory_tree
#     -
#   - recursively sum each dir
#   - select dirs <=100000 into array
#     -
#   - sum array
require 'pry'
require 'rspec'



class ElfDirectory
  attr_accessor :child_dirs, :files, :size
  attr_reader :parent, :name

  def initialize(parent: nil, name: '')
    @parent = parent
    @name = name
    @child_dirs = []
    @files = []
    @size = 0
  end

  def self.calc_size(dir)
    # base case
    return dir.size = dir.files.map(&:size).sum if dir.child_dirs.empty?

    dir.size += dir.files.map(&:size).sum
    dir.child_dirs.each { |child_dir| calc_size(child_dir) }
    dir.size += dir.child_dirs.map(&:size).sum
    return unless dir.files.empty?
  end
end

class ElfFile
  attr_reader :name, :size

  def initialize(name: '', size: 0)
    @name = name
    @size = size
  end
end

class ElfFileSystem
  attr_accessor :current_dir, :root

  def initialize(term_out)
    @current_dir = nil
    @root = ElfDirectory.new(name: '/')
    build_dir_tree(term_out)
    ElfDirectory.calc_size(root)
  end

  def build_dir_tree(term_out)
    term_out.each do |line|
      line = line.split(' ')
      process_line(line)
    end
  end

  def process_line(line)
    case line[0]
    when '$'
      process_command(line[1..])
    else
      process_output(line)
    end
  end

  # com: Array[Strings]
  def process_command(com)
    return self.current_dir = root if com.join(' ') == 'cd /'
    return if com[0] == 'ls'

    # if there is no arg, then its an ls, which I dont care about
    # if there is an arg, then it's a cd and we only care about where we're going
    arg = com[-1]
    self.current_dir = if arg == '..'
                         current_dir.parent
                       else
                         # need to return the actual dir, not an array of one
                         current_dir.child_dirs.select { |dir| dir.name == arg }.pop
                       end
  end

  # out: [String, String]
  def process_output(out)
    lead, name = out
    if lead == 'dir'
      create_dir_if_new(name)
    else
      current_dir.files.push(ElfFile.new(name: name, size: lead.to_i))
    end
  end

  def create_dir_if_new(name)
    return if current_dir.child_dirs.any? { |dir| dir.name == name }

    current_dir.child_dirs.push(ElfDirectory.new(parent: current_dir, name: name))
  end

  def small_dirs(dir:, smalls: [])
    smalls.push(dir.size) if dir.size <= 100_000
    dir.child_dirs.each { |dir| small_dirs(dir: dir, smalls: smalls) }
    smalls
  end
end

console_out = File.read('term_commands.txt').split("\n")
fs = ElfFileSystem.new(console_out)
puts fs.small_dirs(dir: fs.root).sum
