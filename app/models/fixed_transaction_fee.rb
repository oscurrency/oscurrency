class FixedTransactionFee < Fee
  belongs_to :fee_plan, :inverse_of => :fixed_transaction_fees
end
