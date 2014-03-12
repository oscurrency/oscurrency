require 'spec_helper'

describe Fee do
  it "should be associated with a fee plan" do
    fee = Fee.new(fee_plan: nil)
    fee.should_not be_valid
  end
end
