require File.dirname(__FILE__) + '/../spec_helper'

describe TransactsHelper do
  fixtures :client_applications, :fees, :plan_types, :people, :groups, :memberships, :exchanges
  
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
  describe "#paid_fees" do
    it "produces fees summary for transaction." do
      # 40% * transaction amount, which is 10, + 10 per transaction fee = 14 TC fee.
      helper.paid_fees(@transaction).should == "Charged fees: Trade Credits: 14.0 Cash: 0"
    end
  end
end