#!/usr/bin/ruby19
require 'function'
require 'benchmark'

include Math

class Gauss
  def initialize(function, low, high)
    @function, @high, @low = function, high, low
  end
  
  def solve(low = @low, high = @high)
    dx = (high - low)/2
    x = "(((#{low} + #{high}))/2 + (((#{high} - #{low}))/2)*X)"
    gs = Function.new(@function.formula.gsub("X", x))
    #puts x
    
    # coefficients
    c1 = 0.5555556
    c2 = 0.8888889
    c3 = 0.5555556
    x1 = -0.774596669
    x2 = 0.0
    x3 = 0.774596669
    
    dx*(c1 * gs.value(x1)  + c2 * gs.value(x2) + c3 * gs.value(x3))
  end
end

class MGauss < Gauss
  def initialize(function, low, high, m, e = 0.0001)
    @m = m
    @epsilon = e
    super(function, low, high)
  end
  
  def calculate
    print "m".center(10)
    print " | "
    print " Result ".center(20)
    print " | "
    print " Runge ".center(20)
    print " | "
    print " Runge / Runge - 1"
    puts 
    
    last_runge = nil
    
    iterations = 0
    while true
      answer = get(@m)
      
      print @m.to_s.center(10)
      print " | "
      print answer.to_s.center(20)
      print " | "
      runge = (answer - get(@m/2, false)).abs / (2**(3*2) - 1)
      print runge.to_s.center(20) 
      print " | "
      
      if last_runge   
        print last_runge/runge
      end
      puts
      
      last_runge = runge
        
      break if @epsilon >= runge
      
      @m = 2*@m
      last_answer = answer
      iterations += 1
      break if iterations == 20
    end
  end
  
  def get(m, display = true)
    #puts "m = #{m}" if display
    h = (@high - @low).to_f / m
      
    x = @low + h
    answer = 0.0
      
    while true
      value = solve(x-h, x)
      #puts "Points: #{x-h} and #{x}  value=#{value}" if display
      answer += value        
      break if x >= @high
      x += h
    end
    
    answer   
  end
end

formula = Function.new "X*cos(2*(X**2))"
#g = Gauss.new(formula, 0.785398163397448, 1.5707963267949)
#time = Benchmark.realtime { puts "Answer: \t #{g.solve}" }
#puts "Execution time:\t #{time}"

#=begin
if ARGV.size != 2 
  puts "Please enter m and epsilon"
else 
  m = ARGV.first.to_i
  e = ARGV.last.to_f
  g = MGauss.new(formula, 0, PI/2, m, e)
  g.calculate
end
#=end
