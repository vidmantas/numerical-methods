require 'benchmark'
require 'spline'

class SplineClient
  include Spline
  
  def initialize(input)
    File.open(input) do |f|
      @x = f.readline.split(" ")
      @y = f.readline.split(" ")
    end
  end
end

# 21 variantas

#sp = SplineClient.new("tests/spline_test_i.txt")
#puts sp.systems
#puts sp.value(1)

sp2 = SplineClient.new("tests/spline_test_ii.txt")
puts sp2.systems
puts sp2.value(3.5)
