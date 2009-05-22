#!/usr/bin/ruby19
require 'function'
require 'bigdecimal'
include Math

def solve(f, h, display)
  u, x = 0, BigDecimal.new(0.to_s)
  
  last_value = nil
  while true
    k1 = f.value([x.to_f, u])
    k2 = f.value([x.to_f + h/2, u + (h/2)*k1])
    k3 = f.value([x.to_f + h, h*(-1*k1 + 2*k2)])
  
    print x.to_s.center(20) if display
    print u.to_s.center(20) if display
    last_value = u
    puts if display
    
    u = u  + h/6 * ( k1 + 4*k2 + k3 )

    break if x >= BigDecimal.new(1.to_s)
    x = x + BigDecimal.new(h.to_s)
  end
  
  last_value
end

f = Function.new "1 + (0.7 - X[1])*sin(X[1]) - 1.2 * X[1]*X[2]"
#f = Function.new "1"
u, x = 0, 0

h = 0.5
# tau = h
last_runge = nil

2.times do |i|
  puts "h = #{h}"
    
  print "x".center(20)
  print "y".center(20)
  puts
  
  last_value = nil
  answer = nil
  
  current = solve(f, h, true)
  runge = (solve(f, h/2, false) - current).abs / (2**3 - 1)
  puts "Runge: #{runge}"
  
  if last_runge
    puts "Santykis: #{last_runge/runge}"
  end
  last_runge = runge
  
  puts
  
  h = h / 2
  x = 0
  u = 0
end
