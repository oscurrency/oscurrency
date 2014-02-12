require File.dirname(__FILE__) + '/../spec_helper'

describe Account do
  fixtures :fees, :plan_types, :people, :accounts, :groups, :memberships, :exchanges
  
  describe "get month string method" do
    
    it "should return valid month string based on month name." do
      Account.get_by_month_string("January", 1996).should == "1996-1-01"
      Account.get_by_month_string("JANUARY", 1996).should == "1996-1-01"
      Account.get_by_month_string("january", 1996).should == "1996-1-01"
    end
    
  end
  
  before do
    @fees = [ fees(:tc_perc_tran), fees(:tc_tran), fees(:tc_perc_monthly), fees(:tc_monthly), fees(:tc_perc_yearly), fees(:tc_yearly),
              fees(:cash_perc_tran), fees(:cash_tran), fees(:cash_perc_monthly), fees(:cash_monthly), fees(:cash_perc_yearly), fees(:cash_yearly)
            ]
    @plans = [ plan_types(:transactions), plan_types(:monthly), plan_types(:yearly), plan_types(:cash_tran), plan_types(:cash_mon), plan_types(:cash_yearly) ]
    @people = [ people(:aaron), people(:quentin), people(:buzzard), people(:kelly), people(:admin), people(:reserve) ]
    @accounts = [ accounts(:aarons), accounts(:quentins), accounts(:buzzards), accounts(:kellys), accounts(:admins), accounts(:reserves) ]
    @group = groups(:one)
    @memberships = [ memberships(:one), memberships(:two), memberships(:three), memberships(:four) ]
    @exchanges = [ exchanges(:one), exchanges(:two), exchanges(:three), exchanges(:four)]
    begin
      @fees.each do |f|; f.save!; end
      @plans.each do |p|; p.save!; end
      @people.each do |pp|; pp.save!; end
      @accounts.each do |a|; a.save!; end
      @group.save!
      @memberships.each do |m|; m.save!; end
      @transaction.save! 
    rescue => e
      p "Exception: #{e.to_s}"
    end
  end
    
   describe "scheduled task" do
     
     # notes: Quentin working for Kelly. Tests Cash Transactions fess.
     it "should go through all accounts and aggregate transaction cash fees" do
       Account.pay_transaction_cash_fees
       Account.find_by_name("kelly").paid.to_f.should == 14.0
       Account.find_by_name("admin").earned.to_f.should == 4.0
       Account.find_by_name("reserve").earned.to_f.should == 10.0
     end
     
     it "should go through all accounts and aggregate monthly fees" do
       Account.pay_monthly_fees
       Account.find_by_name("aaron").paid.to_f.should == 14.0
       Account.find_by_name("admin").earned.to_f.should == 4.0
       Account.find_by_name("reserve").earned.to_f.should == 10.0
     end
     
     it "should go through all accounts and aggregate yearly fees" do
       Account.pay_yearly_fees
       Account.find_by_name("buzzard").paid.to_f.should == 14.0
       Account.find_by_name("admin").earned.to_f.should == 4.0
       Account.find_by_name("reserve").earned.to_f.should == 10.0
     end
     
   end
 
end