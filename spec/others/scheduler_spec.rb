require File.dirname(__FILE__) + '/../spec_helper'

describe Rufus::Scheduler do
  describe "task" do
    
    before(:each) do
      @today = Date.today
    end
    
    it "should happen on the last day of month" do
      Rufus::Scheduler.parse("0 21 L * *").next_time.to_s.should include(Date.civil(@today.year, @today.month, -1).to_s)
    end
    
    it "should happen on the last day of year" do
      Rufus::Scheduler.parse("0 21 L 12 *").next_time.to_s.should include(Date.civil(@today.year, -1, -1).to_s)
    end
    
  end
end