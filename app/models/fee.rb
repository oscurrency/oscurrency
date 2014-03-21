class Fee < ActiveRecord::Base
  belongs_to :fee_plan
  belongs_to :recipient, :class_name => 'Person', :foreign_key => 'recipient_id'
  attr_readonly :fee_plan
  validates :fee_plan, presence: true
  validates :recipient, presence: true
  
  def self.transaction_tc_fees_sum_for(person, interval)
    today = Date.today
    fees_sum = person.fee_plan.fixed_transaction_fees.sum(:amount)
    perc_fees_sum = person.fee_plan.percent_transaction_fees.sum(:percent).to_percents
    time_start = today.method("beginning_of_#{interval}").call
    time_end = today.method("end_of_#{interval}").call
    transactions = person.transactions.where(:customer_id => person.id).by_time(time_start, time_end)
    tc_fees_sum = fees_sum * transactions.count
    transactions.each do |transaction|
      tc_fees_sum += perc_fees_sum * transaction.amount
    end
    tc_fees_sum
  end
  
end