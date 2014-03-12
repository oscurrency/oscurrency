class Numeric  
  def to_cents
    (self * 100).round
  end
  def to_dollars
    self.to_f / 100
  end
end