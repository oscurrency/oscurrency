class AddStripeCustomerTokenToPeople < ActiveRecord::Migration
  def change
    add_column :people, :stripe_customer_token, :string
  end
end
