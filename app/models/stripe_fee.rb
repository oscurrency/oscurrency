class StripeFee < ActiveRecord::Base
  belongs_to :fee_plan
  attr_readonly :fee_plan
  validates :fee_plan, presence: true
  
  
  def self.transaction_stripe_fees_sum_for(person, interval)
    today = Date.today
    fees_sum = person.fee_plan.fixed_transaction_stripe_fees.sum(:amount)
    perc_fees_sum = person.fee_plan.percent_transaction_stripe_fees.sum(:percent).to_percents
    time_start = today.method("beginning_of_#{interval}").call
    time_end = today.method("end_of_#{interval}").call
    transactions = person.transactions.where(:customer_id => person.id).by_time(time_start, time_end)
    cash_fees_sum = fees_sum * transactions.count
    transactions.each do |transaction|
      cash_fees_sum += perc_fees_sum * transaction.amount
    end
    cash_fees_sum
  end
  
  # Cash fees are aggregated and submitted to credit card processing in batches. 
  # Currently, weekly to Stripe. 
  def self.apply_stripe_transaction_fees(interval)
    desc = "#{interval}ly transaction fees sum"            
    Person.with_stripe_plans.each do |person|
      amount_to_charge = StripeFee.transaction_stripe_fees_sum_for(person, interval)
      StripeOps.charge(amount_to_charge, person.stripe_id, desc) unless amount_to_charge.zero?
    end
  end

end
