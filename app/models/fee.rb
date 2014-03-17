class Fee < ActiveRecord::Base
  belongs_to :fee_plan
  belongs_to :recipient, :class_name => 'Person', :foreign_key => 'recipient_id'
  attr_readonly :fee_plan
  validates :fee_plan, presence: true
  validates :recipient, presence: true
end
