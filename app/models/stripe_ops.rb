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
      stripe_response
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