require File.dirname(__FILE__) + '/../spec_helper'

describe Transact do
  fixtures :fees, :plan_types, :people, :groups, :memberships, :exchanges
  
  before(:each) do
    @tc_perc_tran = fees(:tc_perc_tran)
    @tc_tran = fees(:tc_tran)
    @plan = plan_types(:transactions)
    @worker = people(:aaron)
    @customer = people(:quentin)
    @group = groups(:one)
    @memberships = [ memberships(:one), memberships(:two), memberships(:three) ]
    @transaction = Transact.find(exchanges(:one).id)
    begin
      @tc_perc_tran.save!
      @tc_tran.save!
      @plan.save!
      @worker.save!
      @customer.save!
      @group.save!
      @memberships.each do |m|; m.save!; end
      @transaction.save! 
    rescue => e
      p "Exception: #{e.to_s}"
    end
  end  
    
  describe "paid fees" do
    it "should calculate fees for transaction" do
      @transaction.paid_fees.should == {:"trade-credits" => 14.0, :cash => 0}
    end
  end
  
end