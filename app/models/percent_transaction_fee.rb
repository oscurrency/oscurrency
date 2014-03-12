class PercentTransactionFee < Fee
  belongs_to :fee_plan, :inverse_of => :percent_transaction_fees
end
