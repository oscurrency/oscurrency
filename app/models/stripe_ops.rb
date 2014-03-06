class StripeOps
  
  def self.create_customer(card, expire, cvc, name, email)
   begin
     stripe_response = Stripe::Customer.create(
       :card => {
         :number => card,
         :exp_month => expire.split("/").first,
         :exp_year => expire.split("/").last,
         :cvc => cvc
       },
       :description => name,
       :email => email
     )
   rescue => e
     stripe_response = handle_error(e)
   else
     stripe_response
   end
  end
  # Unfortunately:
  # A positive integer in the smallest currency unit (e.g 100 cents to charge $1.00).
  def self.charge(amount, stripe_id, description)
    if amount.to_cents < 50
      return "Minimum amount that can be submitted via stripe is 50 cents!"
    end
    begin
      stripe_response = Stripe::Charge.create(
        :amount => amount.to_cents,
        :currency => "usd",
        :customer => stripe_id,
        :description => description
      )
    rescue => e
      stripe_response = handle_error(e)
    else
      charge_params = {
        :stripe_id => stripe_response[:id],
        :person_id => Person.find_by_stripe_id(stripe_id).id,
        :amount => amount,
        :description => description,
        :status => 'paid'
      }
      Charge.create(charge_params)
      stripe_response
    end
  end
  
  def self.all_charges_for_user(stripe_id)
    all_charges = Array.new
    charges = Stripe::Charge.all(:customer => stripe_id )
    charges.each do |charge|
      all_charges << [ 
                      charge[:id], 
                      charge[:amount], 
                      Person.find_by_stripe_id(charge[:customer]).email,
                      charge[:description],
                      charge[:refunded] ]
    end
    all_charges
  end
  
  def self.refund_charge(charge_id)
    begin
      Stripe::Charge.retrieve(charge_id)
    rescue => e  
      stripe_response = handle_error(e)
    else
      Charge.find_by_stripe_id(charge_id).update_attribute(:status, 'refunded')
      "Charge refunded"
    end
  end
  
  private
  
  def self.handle_error(e)
    case e.class
    when Stripe::CardError
      return e.json_body[:error][:message]
    when Stripe::InvalidRequestError
      return e.json_body[:error][:message]
      # sth, maybe exception notifier?
    when Stripe::AuthenticationError
      e.json_body[:error][:message]
      # sth
    else
      # notifier?
      return e.to_s
    end 

  end
end