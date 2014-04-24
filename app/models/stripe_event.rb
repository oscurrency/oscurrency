class StripeEvent < ActiveRecord::Base
  attr_accessible :stripe_id, :stripe_type

  validates_uniqueness_of :stripe_id

  def event_object
    event = Stripe::Event.retrieve(stripe_id)
    event.data.object
  end
end
