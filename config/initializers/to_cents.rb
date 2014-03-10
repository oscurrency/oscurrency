class Numeric
  def to_cents
    (self.round(2) * 100).to_i
  end
end