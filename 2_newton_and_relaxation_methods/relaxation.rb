#!/usr/bin/ruby
require "function"

class Relaxation
  def initialize(function, epsilon, m1, m2, first_value, q =1)
    @function = function
    @epsilon  = epsilon
    @m1, @m2, @last_x = m1, m2, first_value
    @q = q
  end
  
  def solve
    iterations = 0
    while true
      @next_x = (1.0 - w)*@last_x + w*@function.value(@last_x)
      print "Iteration #{iterations}\t x = #{@next_x}"  
      if accurate?(@next_x)
        break
      else
        @last_x = @next_x
      end
      
      iterations += 1
      break if iterations == 100000  
    end
    
    @next_x
  end
  
  def w
    @w ||= 2.0 / (2.0 + @m1.abs + @m2.abs);
  end
  
  def accurate?(x)
    acc = x - @last_x
    print "\t paklaida: #{acc.abs}\n"
    acc.abs <= @epsilon
  end
end

r = Relaxation.new(
  Function.new("#{Math::E}**(-3*X**2)"),
  0.0000001,
  -1.5,
  -1.0,
  0.2
)
puts "Atsakymas: #{r.solve}"

