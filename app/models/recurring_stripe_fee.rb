class RecurringStripeFee < StripeFee
  belongs_to :fee_plan, :inverse_of => :recurring_stripe_fees
  before_create :retrieve_interval_and_amount

  def retrieve_interval_and_amount
    stripe_plan = Stripe::Plan.retrieve(self.plan)
    self.interval = stripe_plan.interval
    self.amount = stripe_plan.amount / 100
  end
end
