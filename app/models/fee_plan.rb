class FeePlan < ActiveRecord::Base
  validates_presence_of	:name
  validates_length_of :name,  :maximum => 100
  validates_length_of :description,  :maximum => 255

  has_many :people, :dependent => :restrict
  has_many :recurring_fees, :dependent => :destroy, :inverse_of => :fee_plan
  has_many :recurring_stripe_fees, :dependent => :destroy, :inverse_of => :fee_plan
  has_many :fixed_transaction_fees, :dependent => :destroy, :inverse_of => :fee_plan
  has_many :percent_transaction_fees, :dependent => :destroy, :inverse_of => :fee_plan
  has_many :fixed_transaction_stripe_fees, :dependent => :destroy, :inverse_of => :fee_plan
  has_many :percent_transaction_stripe_fees, :dependent => :destroy, :inverse_of => :fee_plan

  accepts_nested_attributes_for :recurring_fees
  accepts_nested_attributes_for :recurring_stripe_fees
  accepts_nested_attributes_for :fixed_transaction_fees
  accepts_nested_attributes_for :percent_transaction_fees
  accepts_nested_attributes_for :fixed_transaction_stripe_fees
  accepts_nested_attributes_for :percent_transaction_stripe_fees

  default_scope :order => 'name ASC'

  def apply_recurring_fees(interval)
    group = Preference.first.default_group
    recurring_fees.each do |f|
      if interval == f.interval
        self.people.each do |payer|
          e=group.exchanges.build(amount: f.amount)
          e.customer = payer
          e.worker = f.recipient
          e.save!
        end
      end
    end
  end
end