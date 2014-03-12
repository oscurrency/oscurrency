require File.dirname(__FILE__) + '/../spec_helper'

describe Transact do
  fixtures :fees, :plan_types, :people, :groups, :memberships, :exchanges
<<<<<<< HEAD

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
=======
>>>>>>> 8fe4ed4... Little tests cleanup.
    
  describe "paid fees" do
    it "should calculate fees for transaction" do
      # 40% * transaction amount, which is 10, + 10 per transaction fee = 14 TC fee.
      Transact.find(exchanges(:one).id).paid_fees.should == {:"trade-credits" => 14.0, :cash => 0}
    end
  end
  
end