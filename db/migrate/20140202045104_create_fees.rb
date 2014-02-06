class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.string  :event
      t.string  :fee_type
      t.integer :amount
      t.string  :account
      t.references :plan_type

      t.timestamps
    end
  end
end