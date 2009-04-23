a = []
%w{-1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4}.each do |x|
  x = x.to_f
  puts x/(1+2*x**2)
end

