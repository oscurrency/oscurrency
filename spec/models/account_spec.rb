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
    
   describe "scheduled task" do
     
     # TODO write stripe test. It was there just for mockup.
     # notes: Quentin working for Kelly. Tests Cash Transactions fess.
     xit "should go through all accounts and aggregate transaction cash fees" do
       Account.pay_transaction_cash_fees
       Account.find_by_name("kelly").paid.to_f.should == 14.0
       Account.find_by_name("mixed").paid.to_f.should == 14.0
       Account.find_by_name("admin").earned.to_f.should == 8.0
       Account.find_by_name("reserve").earned.to_f.should == 20.0
     end
     # TODO write stripe test. It was there just for mockup.
     # notes: Quentin working for Aaron.
     xit "should go through all accounts and aggregate monthly fees" do
       Account.pay_monthly_fees
       Account.find_by_name("aaron").paid.to_f.should == 14.0
       Account.find_by_name("mixed").paid.to_f.should == 14.0
       Account.find_by_name("admin").earned.to_f.should == 8.0
       Account.find_by_name("reserve").earned.to_f.should == 20.0
     end
     # TODO write stripe test. It was there just for mockup.
     # notes: Quentin working for Buzzard.
     xit "should go through all accounts and aggregate yearly fees" do
       Account.pay_yearly_fees
       Account.find_by_name("buzzard").paid.to_f.should == 14.0
       Account.find_by_name("admin").earned.to_f.should == 4.0
       Account.find_by_name("reserve").earned.to_f.should == 10.0
     end
     
   end
   
   describe "fees invoice for month" do
     
     it "should return fees sums in trade credits and cash" do
       # notes: Quentin working for Mixed.
       fees = Account.find_by_name("mixed").fees_invoice_for_month(Date.today.month, Date.today.year)
       # 10 per transaction + 10 monthly + 40% per transaction + 40% from sum of all transactions in the month
       fees[:"trade-credits"].should == 28.0
       fees[:cash].to_f.should == 28.0
     end
     
   end
 
end