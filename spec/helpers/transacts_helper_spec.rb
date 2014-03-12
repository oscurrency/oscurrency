require File.dirname(__FILE__) + '/../spec_helper'

describe TransactsHelper, :type => :helper do

  fixtures :fees, :plan_types, :people, :groups, :memberships, :exchanges 

  
  describe "#paid_fees" do
    it "produces fees summary for transaction." do
      # 40% * transaction amount, which is 10, + 10 per transaction fee = 14 TC fee.
      helper.paid_fees(Transact.find(exchanges(:one).id)).should == "Charged fees: Trade Credits: 14.0 Cash: 0"
    end
  end
end