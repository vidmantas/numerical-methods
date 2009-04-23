require 'rubygems'
require 'active_support'

module TridiagonalMatrix
  def solve
    return false unless @matrix.is_a?(Hash)
    
    convert
    check
    forward
    return backward
  end
  
  def check
    @size = @matrix["d"].size
    
    all_equals_or_more = true
    one_more = false
    @size.times do |i|
      all_equals_or_more = false if @matrix["b"][i+1].abs < @matrix["a"][i+1].abs + @matrix["c"][i+1].abs
      one_more = true if @matrix["b"][i+1].abs > @matrix["a"][i+1].abs + @matrix["c"][i+1].abs
    end
    
    if !all_equals_or_more or !one_more
      puts "Convergence check failed"
      exit
    end
  end
  
  def forward
    @cs = []
    @ds = []
    
    @size.times do |i|
      if i.zero?
        @cs[1] = -1 * (@matrix["c"][1] / @matrix["b"][1])
        @ds[1] = @matrix["d"][1] / @matrix["b"][1]
      else
        denominator = @matrix["a"][i+1] * @cs[i] + @matrix["b"][i+1] 
        @cs[i+1]    = -1 * (@matrix["c"][i+1] / denominator) unless i+1 == @size
        @ds[i+1]    = (@matrix["d"][i+1] - @matrix["a"][i+1] * @ds[i]) / denominator
      end
    end
  end
  
  def backward
    solution = []
    @size.downto 1 do |i|
      if i == @size
        solution[i] = @ds[i]
      else
        solution[i] = @cs[i] * solution[i+1] + @ds[i]
      end
    end
    
    solution.shift
    solution
  end
  
  def convert
    @matrix.each do |key, values|
      values.each do |index, value|
        #@matrix[key][index] = BigDecimal.new(value.to_s)
        @matrix[key][index] = value.to_f
      end
    end
  end
end
