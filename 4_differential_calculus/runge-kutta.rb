#!/usr/bin/ruby19
require 'function'
include Math

def solve(f, h, display)
  u, x = 0, 0
  
  last_value = nil
  while x <= 1 do
    k1 = f.value([x, u])
    k2 = f.value([x + (2.0/3)*h, u + (2.0/3)*k1*h])
    k3 = f.value([x + (2.0/3)*h, u + (2.0/3)*k2*h])
  
    print x.to_s.center(20) if display
    print u.to_s.center(20) if display
    last_value = u
    puts if display
    
    u = u  + 1.0/8 * (2*k1 + 3*k2 + 3*k3) * h
    x = x + h
  end
  
  last_value
end

f = Function.new "1 + (0.7 - X[1])*sin(X[1]) - 1.2 * X[1]*X[2]"

u, x = 0, 0

h = 0.1
# tau = h

4.times do |i|
  puts "h = #{h}"
    
  print "x".center(20)
  print "y".center(20)
  puts
  
  last_value = nil
  answer = nil
  
  current = solve(f, h, true)
  runge = (solve(f, h/2, false) - current).abs / (2**3 - 1)
  puts "Runge: #{runge}"
  
  puts
  
  h = h / 2
  x = 0
  u = 0
end
