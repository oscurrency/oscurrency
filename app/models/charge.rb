class Charge < ActiveRecord::Base
  attr_accessible :stripe_id, :description, :amount, :status, :person_id
  
  validates_inclusion_of :status, :in => ['pending', 'paid', 'refunded', 'partially refunded', 'disputed']
  belongs_to :person
  validates_presence_of [:stripe_id, :description, :amount, :status, :person_id]
  
  def dispute_link
    "https://manage.stripe.com/" + Rails.configuration.stripe[:mode] + "/payments/" + self.stripe_id
  end
end