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
    rescue Stripe::CardError => e
      return e.json_body[:error][:message]
    #rescue Stripe::InvalidRequestError => e
      # Invalid parametes supplied to Stripe API - exception notifier?
    #rescue Stripe::AuthenticationError => e
      # Auth with Stripe's API failed - exception notifier?
    #rescue Stripe::APIConnectionError => e
      # Network communication to Stripe failed - exception notifier?
    rescue Stripe::StripeError => e
      return e.to_s
      #exception notifier
    rescue => e
      return e.to_s
    else
      return stripe_response
    end
  
  end
end