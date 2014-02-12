require File.dirname(__FILE__) + '/../spec_helper'

describe TransactsHelper do
  fixtures :fees, :plan_types, :people, :groups, :memberships, :exchanges
  
  before(:each) do
    @fees = [ fees(:tc_perc_tran), fees(:tc_tran) ]
    @plans = [ plan_types(:transactions) ]
    @people = [ people(:aaron), people(:quentin) ]
    @group = groups(:one)
    @memberships = [ memberships(:one), memberships(:two), memberships(:three) ]
    @transaction = Transact.find(exchanges(:one).id)
    begin
      @fees.each do |f|; f.save!; end
      @plans.each do |p|; p.save!; end
      @people.each do |pp|; pp.save!; end
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