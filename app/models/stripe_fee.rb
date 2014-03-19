class StripeFee < ActiveRecord::Base
  belongs_to :fee_plan
  attr_readonly :fee_plan
  validates :fee_plan, presence: true
  
  # Cash fees are aggregated and submitted to credit card processing in batches. 
  # Currently, weekly to Stripe. 
  def self.apply_stripe_transaction_fees
    week_interval = Date.today.beginning_of_week.strftime("%d %B, %Y") + ' - ' +
                    Date.today.end_of_week.strftime("%d %B, %Y")
    desc = "Transaction fees sum for week: #{week_interval}"            
    Person.with_stripe_plans.each do |person|
      customer_card = Stripe::Customer.retrieve(person.stripe_id).cards.first.id 
      # Sum all fees-per-transaction amounts
      fees_sum = person.fee_plan.fixed_transaction_stripe_fees.sum(:amount)
      # Take number of transactions
      transactions_count = person.transactions.where(:customer_id => person.id).count
      unless fees_sum.zero? || transactions_count.zero?
        # For each transaction take a fee:
        Stripe::Charge.create(
          :amount => (fees_sum * transactions_count).to_cents,
          :currency => "usd",
          :card => customer_card,
          :description => desc
        )
      end
      # Sum all percentage-fees-per-transaction percentages
      fees_perc_sum = (person.fee_plan.percent_transaction_stripe_fees.sum(:percent)).to_percents
      unless fees_perc_sum.zero? 
        # For each transaction take a fee:
        person.transactions.where(:customer_id => person.id).each do |transaction|
          Stripe::Charge.create(
            :amount => (fees_perc_sum * transaction.amount).to_cents,
            :currency => "usd",
            :card => customer_card,
            :description => desc
          )
        end
      end
    end
  end

end
