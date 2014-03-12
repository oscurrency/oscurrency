require 'spec_helper'
require 'cancan/matchers'

describe FeePlan do
  fixtures :people

  before(:each) do
    @valid_attributes = {
      name: 'plan1'
    }
    @p = people(:admin)
  end

  it "should create a new instance given valid attributes" do
    fee_plan = FeePlan.create!(@valid_attributes)
  end
end
