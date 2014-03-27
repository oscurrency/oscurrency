require 'spec_helper'

describe StripeController do
  fixtures :people, :charges
  StripeTester.webhook_url = "http://localhost:3000/stripe_callback"
  before(:each) do
    @charge = charges(:two_dollars)
  end
  
  describe 'POST handle_callback from Stripe API webhook' do
    
    it 'should respond with status 200' do
      StripeTester.create_event(:invoice_created)
      response.status.should == 200
    end
    
    it 'should receive event and change charge status to disputed' do
      dispute_hash = {:data => {:object => {:charge => @charge.stripe_id, :amount => @charge.amount.to_cents}}}
      StripeTester.create_event(:charge_dispute_created, dispute_hash , :method => :merge)
      Charge.find_by_stripe_id(@charge.stripe_id).status.should == 'disputed'
    end
    
    it 'should receive event and change charge status to partially refunded' do
      dispute_hash = {:data => {:object => {:charge => @charge.stripe_id, :status => 'lost', :amount => (@charge.amount/2).to_cents}}}
      StripeTester.create_event(:charge_dispute_closed, dispute_hash , :method => :merge)
      Charge.find_by_stripe_id(@charge.stripe_id).status.should == 'partially refunded'
    end
    
    it 'should receive event and change charge status to fully refunded' do
      dispute_hash = {:data => {:object => {:charge => @charge.stripe_id, :status => 'lost', :amount => @charge.amount.to_cents}}}
      StripeTester.create_event(:charge_dispute_closed, dispute_hash , :method => :merge)
      Charge.find_by_stripe_id(@charge.stripe_id).status.should == 'refunded'
    end
    
    it 'should receive event and change charge status to paid' do
      dispute_hash = {:data => {:object => {:charge => @charge.stripe_id, :status => 'won'}}}
      StripeTester.create_event(:charge_dispute_closed, dispute_hash , :method => :merge)
      Charge.find_by_stripe_id(@charge.stripe_id).status.should == 'paid'
    end
  
  end
end