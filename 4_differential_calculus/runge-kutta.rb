#!/usr/bin/ruby19
require 'function'
include Math


f = Function.new "1 + (0.7 - X[1])*sin(X[1]) - 1.2 * X[1]*X[2]"

u, x = 0, 0

h = 0.1
# tau = h

4.times do |i|
  puts "h = #{h}"
    
  print "x".center(20)
  print "y".center(20)
  puts
  
  while x <= 1 do
    k1 = f.value([x, u])
    k2 = f.value([x + (2.0/3)*h, u + (2.0/3)*k1*h])
    k3 = f.value([x + (2.0/3)*h, u + (2.0/3)*k2*h])
  
    print x.to_s.center(20)
    print u.to_s.center(20)
    puts
    
    u = u  + 1.0/8 * (2*k1 + 3*k2 + 3*k3) * h
    last_u = u if x == h
    x = x + h
    
    # runge error
    #puts "Runge: #{}" if last_u
  end
  puts
  
  h = h / 2
  x = 0
  u = 0
end
