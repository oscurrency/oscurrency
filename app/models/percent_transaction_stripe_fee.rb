class PercentTransactionStripeFee < StripeFee
  belongs_to :fee_plan, :inverse_of => :percent_transaction_stripe_fees
end
