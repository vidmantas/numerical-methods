#!/usr/bin/ruby
require "function"

class Newton
  def initialize(function, first_value, epsilon, delta)
    @function = function
    @last_x = first_value
    @epsilon = epsilon
    @delta = delta
  end
  
  def solve
    iterations = 0
    while true
      @next_x = @last_x - @function.value(@last_x) / @function.diff(@last_x)
      if accurate?(@next_x)
        break
      else
        puts "Point for iteration #{iterations} = #{@next_x}"
      end
      
      iterations += 1
      @last_x = @next_x
      break if iterations == 100000  
    end
    
    [@next_x, iterations]
  end
  
  def accurate?(x)
    @function.value(x) == 0.0 or (x - @last_x).abs < @epsilon
  end
end

n = Newton.new(
  Function.new("#{Math::E}**(-3*X**2) - X"), 
  0.2, 
  0.0000001,
  0.000001
)

results = n.solve
puts "Result: #{results.first}"
puts "Iterations: #{results.last}"

