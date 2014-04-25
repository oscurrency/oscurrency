class FeePlan < ActiveRecord::Base
  validates_presence_of	:name
  validates_length_of :name,  :maximum => 100
  validates_length_of :description,  :maximum => 255
  validate :does_not_include_bogus_recurring_stripe_fee

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
  scope :enabled, where(enabled: true)

  def does_not_include_bogus_recurring_stripe_fee
    if has_a_recurring_stripe_fee?
      if enabled?
        recurring_stripe_fees.each do |stripe_fee|
          stripe_plan = Stripe::Plan.retrieve(stripe_fee.plan)
        end
      end
    end
  rescue Stripe::InvalidRequestError => e
    Rails.logger.info "does_not_include_bogus_recurring_stripe_fee: #{e.message}"
    errors.add(:enabled, "cannot be set with stripe plan that does not exist")
  end

  def has_a_recurring_stripe_fee?
    recurring_stripe_fees.any?
  end

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

  def apply_transaction_fees(txn)
    percent_transaction_fees.each do |fee|
        e=txn.group.exchanges.build(amount: txn.amount*(fee.percent/100))
        e.metadata = txn.metadata
        e.customer = txn.worker
        e.worker = fee.recipient
        e.save!
    end

    fixed_transaction_fees.each do |fee|
        e=txn.group.exchanges.build(amount: fee.amount)
        e.metadata = txn.metadata
        e.customer = txn.worker
        e.worker = fee.recipient
        e.save!
    end
  end
end
