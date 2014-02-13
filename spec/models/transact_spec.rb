require File.dirname(__FILE__) + '/../spec_helper'

describe Transact do
  fixtures :fees, :plan_types, :people, :groups, :memberships, :exchanges
    
  describe "paid fees" do
    it "should calculate fees for transaction" do
      # 40% * transaction amount, which is 10, + 10 per transaction fee = 14 TC fee.
      Transact.find(exchanges(:one).id).paid_fees.should == {:"trade-credits" => 14.0, :cash => 0}
    end
  end
  
end