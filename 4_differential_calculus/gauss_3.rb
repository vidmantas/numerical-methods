#!/usr/bin/ruby19
require 'function'
require 'benchmark'

include Math

class Gauss
  def initialize(function, high, low)
    @function, @high, @low = function, high, low
  end
  
  def solve
    dx = (@high - @low)/2
    x = "(((#{@low} + #{@high})*#{dx})/2 + (((#{@high} - #{@low})*#{dx})/2)*X)"
    gs = Function.new(@function.formula.gsub("X", x))
    
    # coefficients
    c1 = 0.5555556
    c2 = 0.8888889
    c3 = 0.5555556
    x1 = -0.774596669
    x2 = 0.0
    x3 = 0.774596669
    
    c1 * gs.value(x1)  + c2 * gs.value(x2) + c3 * gs.value(x3)
  end
end

formula = Function.new "X*cos(2*(X**2))"
g = Gauss.new(formula, 0, PI/2)
time = Benchmark.realtime { puts "Answer: \t #{g.solve}" }
puts "Execution time:\t #{time}"
