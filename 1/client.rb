require 'tridiagonal_matrix'
require 'benchmark'

class Solve
  include TridiagonalMatrix
  
  def initialize(input_file)
    @matrix = { "a" => {}, "b" => {}, "c" => {}, "d" => {}}
    
    if File.exists?(input_file)
      File.open(input_file) do |f|
        lines = f.readlines
        lines.each_with_index do |line, index|
          @matrix["d"][index+1] = line.split("|").last.strip
          
          if index.zero?
            @matrix["a"][index+1] = 0
            @matrix["b"][index+1] = line.split(" ").first
            @matrix["c"][index+1] = line.split(" ")[1]
          elsif index+1 == lines.size
            @matrix["a"][index+1] = line.split(" ").first
            @matrix["b"][index+1] = line.split(" ")[1]
            @matrix["c"][index+1] = 0
          else
            @matrix["a"][index+1] = line.split(" ").first
            @matrix["b"][index+1] = line.split(" ")[1]
            @matrix["c"][index+1] = line.split(" ")[2]
          end
        end
      end      
    else
      puts "Cannot locate #{input_file}, exiting..."  
      exit
    end
    
#    @matrix.each do |key, value|
#      puts "#{key} = #{value.inspect}"
#    end
  end
end

puts Benchmark.measure { 
  s = Solve.new "tests/test2.txt"
  puts s.solve
}
