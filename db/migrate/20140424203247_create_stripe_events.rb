class CreateStripeEvents < ActiveRecord::Migration
  def change
    create_table :stripe_events do |t|
      t.string :stripe_id
      t.string :stripe_type

      t.timestamps
    end
  end
end
