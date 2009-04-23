class Function
  def initialize(f, delta = 0.0000001)
    @formula = f
    @delta = delta
  end
  
  def value(x)
    eval(@formula.gsub("X", x.to_s))
  end
  
  def diff(x)
    (self.value(x + @delta) - self.value(x)) / @delta
  end
end
