class FixedTransactionStripeFee < StripeFee
  belongs_to :fee_plan, :inverse_of => :fixed_transaction_stripe_fees
end
