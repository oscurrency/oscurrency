class RecurringStripeFee < StripeFee
  validates :interval, inclusion: { in: ['month', 'year'], message: "%{value} is not a valid interval." }
  belongs_to :fee_plan, :inverse_of => :recurring_stripe_fees
  # Consistency
  before_create :retrieve_interval_and_amount
  after_create :create_stripe_plan
  after_destroy :destroy_stripe_plan
  
  
  def create_stripe_plan
    plan_name = create_plan_id
    Stripe::Plan.create(
      :amount => self.amount.to_cents,
      :interval => self.interval,
      :currency => 'usd',
      :id => plan_name,
      :name => plan_name
    )
    self.update_attribute(:plan, plan_name)
  end
  
  def destroy_stripe_plan
    Stripe::Plan.retrieve(self.plan).delete
  end
  
  def retrieve_interval_and_amount
    stripe_plan = Stripe::Plan.retrieve(self.plan)
    self.interval = stripe_plan.interval
    self.amount = stripe_plan.amount.to_dollars
  end
  
  private
  
  def create_plan_id
    unless self.percent.zero?
      "#{self.interval.capitalize}ly: #{self.percent}%" 
    else
      "#{self.interval.capitalize}ly: #{self.amount}$"
    end
  end
end
