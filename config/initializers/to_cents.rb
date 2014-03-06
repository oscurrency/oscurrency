class Numeric
  def to_cents
    (self * 100).to_i
  end
end