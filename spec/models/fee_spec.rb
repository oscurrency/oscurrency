require 'spec_helper'

describe Fee do
  fixtures :people

  before(:each) do
    @p = people(:quentin)
    @p2 = people(:aaron)
    @p3 = people(:kelly)
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :mode => Group::PUBLIC,
      :unit => "value for unit",
      :asset => "coins",
      :adhoc_currency => true
    }
    @g = Group.new(@valid_attributes)
    @g.owner = @p
    @g.save!
    Membership.request(@p2,@g,false)
    Membership.request(@p3,@g,false)

    @pref = Preference.first
    @pref.default_group_id = @g.id
    @pref.save!
  end

  it "should be associated with a fee plan" do
    fee = Fee.new(fee_plan: nil)
    fee.should_not be_valid
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