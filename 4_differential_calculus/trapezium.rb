#!/usr/bin/ruby19
require 'function'
require 'benchmark'

include Math

class Trapezium
  def initialize(function, low, high)
    @function, @high, @low = function, high, low
  end
  
  def solve(n)
    h = (@high - @low)/n

    answer = 0.0
    n.times do |i|
      interval_starts = @low + h*i
      interval_ends   = @low + h*(i+1)
      answer += ((@function.value(interval_starts) + @function.value(interval_ends))/2)*(interval_ends - interval_starts)
    end
    
    [answer, h]
  end
end

formula = Function.new "X*cos(2*(X**2))"
t = Trapezium.new(formula, 0, PI/2)

n = ARGV.first.to_i
print "N".center(4)
print " | "
print "h".center(20)
print " | "
print "Result".center(20)
print " | "
print " Runge ".center(20)
print " | " 
print " Execution time ".center(20)
puts
100.times { print "-" }
puts

next_result, next_h = nil

5.times do |i|
  time = Benchmark.realtime do
    n = n*2 unless i.zero?
    print n.to_s.center(4)
    print " | "
    
    result, h = if next_result.nil? 
      t.solve(n)
    else
      [next_result, next_h]
    end
    
    print h.to_s.center(20)
    print " | "
    next_result, next_h = t.solve(n*2)
    
    print result.to_s.center(20)
    print " | "
    print (next_result - result).abs.to_s.center(20)
  end
  
  print " | " 
  print time
  puts
end

