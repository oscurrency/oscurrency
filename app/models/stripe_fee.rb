class StripeFee < ActiveRecord::Base
  belongs_to :fee_plan
  attr_readonly :fee_plan
  validates :fee_plan, presence: true
end
