class Charge < ActiveRecord::Base
  attr_accessible :stripe_id, :description, :amount, :status, :person_id
  
  validates_inclusion_of :status, :in => ['pending', 'paid', 'refunded', 'partially refunded', 'disputed']
  belongs_to :person
  validates_presence_of [:stripe_id, :description, :amount, :status, :person_id]
  
  # Data from db. For Stripe see StripeOps#all_charges_for_person
  def self.all_charges_for_person(person_id)
    Charge.find_all_by_person_id(2)
          .map{ |c| [c.amount, 
                     c.status, 
                     c.description, 
                     c.created_at.strftime("%B %d, %Y %H:%M")] }
  end
  
  def dispute_link
    "https://manage.stripe.com/" + Rails.configuration.stripe[:mode] + "/payments/" + self.stripe_id
  end
end