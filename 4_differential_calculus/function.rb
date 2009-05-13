class Function
  include Math
  attr_accessor :formula
  
  def initialize(f, delta = 0.0000001)
    @formula = f
    @delta = delta
  end
  
  def value(x)
    f = if x.is_a?(Array)
      c_formula = @formula.dup
      x.each_with_index do |value, index|
        c_formula.gsub!("X[#{index+1}]", value.to_s)
      end
      c_formula
    else
      @formula.gsub("X", x.to_s) 
    end
    
    eval(f)
  end
  
  def diff(x)
    raise "Not supported" if x.is_a?(Array)
    (self.value(x + @delta) - self.value(x)) / @delta
  end
end
