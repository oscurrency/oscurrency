class Fee < ActiveRecord::Base
  
  validates_presence_of [:event, :fee_type, :account, :amount]
  validates :amount, numericality: { :greater_than => 0 }
  
  belongs_to :plan_type

end