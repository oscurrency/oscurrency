class RecurringStripeFee < StripeFee
  validates :interval, inclusion: { in: ['month', 'year'], message: "%{value} is not a valid interval." }
  validates_presence_of :fee_plan
  belongs_to :fee_plan, :inverse_of => :recurring_stripe_fees
  # Consistency
  before_create :retrieve_interval_and_amount
  # Create recurring plan on Stripe.
  before_create :create_stripe_plan
  # Subscribe everyone to pay the new fee.
  after_create :subscribe_people_with_fee_plan
  # Destroy the plan on Stripe, so customers are unsubscribed.
  after_destroy :destroy_stripe_plan
  
  
  def create_stripe_plan
    if self.valid?
      plan_name = create_plan_id
      stripe_ret = StripeOps.create_stripe_plan(self.amount, self.interval, plan_name)
      if stripe_ret.kind_of? Stripe::Plan
        self.plan = plan_name
      else
        return false
      end
    end
  end
  
  def destroy_stripe_plan
    stripe_ret = Stripe::Plan.retrieve(self.plan).delete
    true if stripe_ret.kind_of? Stripe::Plan
    false
  end
  
  def retrieve_interval_and_amount
    unless self.plan.blank?
      stripe_plan = Stripe::Plan.retrieve(self.plan)
      self.interval = stripe_plan.interval
      self.amount = stripe_plan.amount.to_dollars
    end
  end
  
  private
  
  def create_plan_id
    unless self.percent.zero?
      "#{self.interval.capitalize}ly: #{self.percent}%" 
    else
      "#{self.interval.capitalize}ly: #{self.amount}$"
    end
  end
  
  def subscribe_people_with_fee_plan
    self.fee_plan.subscribe_payers_to_stripe(self.plan)
  end
end
