require File.dirname(__FILE__) + '/../spec_helper'

describe Fee do
  fixtures :fees
  
  describe "attributes" do
    before(:each) do
      @fee = fees(:tc_perc_tran)
    end
    it "should be vaild" do
      @fee.should be_valid
    end
  
    it "should have amount greater than zero." do
      @fee.amount = 0
      @fee.should_not be_valid
      @fee.errors[:amount].first.should == "must be greater than 0"
    end
  end
end