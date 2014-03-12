class RecurringFee < Fee
  belongs_to :fee_plan, :inverse_of => :recurring_fees
end
