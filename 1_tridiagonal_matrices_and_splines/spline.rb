require 'tridiagonal_matrix'

module Spline
  include TridiagonalMatrix
  
  def systems
    @n = @x.size
    convert_spline_input
    count_h
    count_f
    count_g
    @g = solve
    count_systems
  end  
  
  def value(point)
    systems if @s.nil?
    system = 0 
    @x.size.times do |i|
      if @x[i+1] 
        if point >= @x[i] and point <= @x[i+1] 
          system = i
          break
        end
      else
        raise "Point invalid"
      end
    end
    
    x = point
    eval @s[system]
  end
  
  
  private
  
  def count_systems
    @s = []
    (@n-1).times do |i|
      sub = "x - #{@x[i]}"
      @s[i] = "#{@y[i]} + #{get_e(i)} * (#{sub}) + #{get_big_g(i)} * ((#{sub})**2) + #{get_big_h(i)} * ((#{sub})**3)"
    end
    @s
  end
  
  def convert_spline_input
    @x.map!{ |element| element = element.to_f } 
    @y.map!{ |element| element = element.to_f }
  end
  
  def count_h
    @h = []
    (@n - 1).times do |i|
      @h[i] = @x[i+1] - @x[i]
    end
  end
  
  def count_f
    raise "H not set" unless defined?(@h)
    @f = []
    (@n - 1).times do |i|
      @f[i] = (@y[i+1] - @y[i])/@h[i]
    end
  end
  
  def count_g
    # sudarom triistrizaine matrica
    @matrix = { "a" => {}, "b" => {}, "c" => {}, "d" => {}}
    
    @n.times do |i|
      if i.zero? or i == @n-1
        # pirmas elementas arba paskutinis
        @matrix['a'][i+1] = @matrix['c'][i+1] = @matrix['d'][i+1] = 0.0
        @matrix['b'][i+1] = 1.0    
      else
        @matrix['a'][i+1] = @h[i-1] 
        @matrix['b'][i+1] = 2*(@h[i]+@h[i-1])
        @matrix['c'][i+1] = @h[i]
        @matrix['d'][i+1] = 6*(@f[i]-@f[i-1])
      end
    end
  end 
  
  def get_e(i)
    (@y[i+1] - @y[i])/@h[i] - @g[i+1]*(@h[i]/6) - @g[i]*(@h[i]/3)
  end
  
  def get_big_g(i)
    @g[i]/2
  end
  
  def get_big_h(i)
    (@g[i+1] - @g[i])/(6*@h[i])
  end
end
