class RecurringFee < Fee
  validates :interval, inclusion: { in: ['month', 'year'], message: "%{value} is not a valid interval." }
  belongs_to :fee_plan, :inverse_of => :recurring_fees
end
