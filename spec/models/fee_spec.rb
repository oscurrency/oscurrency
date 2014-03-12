require 'spec_helper'

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

  it "should charge the recipient a fixed transaction fee" do
    fee_plan = FeePlan.new(name: 'test')
    fee_plan.save!
    fee = FixedTransactionFee.new(fee_plan: fee_plan, amount: 0.1, recipient: @p3)
    fee.save!
    @p.fee_plan = fee_plan
    @p.save!
    @e = @g.exchange_and_fees.build(amount: 2.0)
    @e.worker = @p
    @e.customer = @p2
    @e.notes = 'Generic'
    @e.save!
    account_after_payment = @p.account(@g)
    account_after_payment.balance.should == 1.9
  end

  #it "should charge the recipient a percentage transaction fee" do
  #end
end