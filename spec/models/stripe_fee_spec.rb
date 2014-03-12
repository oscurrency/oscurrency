require 'spec_helper'

describe StripeFee do
  it "should be associated with a fee plan" do
    stripe_fee = StripeFee.new(fee_plan: nil)
    stripe_fee.should_not be_valid
  end
end
