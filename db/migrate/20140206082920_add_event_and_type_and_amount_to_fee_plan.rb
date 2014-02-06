class AddEventAndTypeAndAmountToFeePlan < ActiveRecord::Migration
  def self.up
    add_column :fee_plans, :event, :string
    add_column :fee_plans, :pay_type, :string
    add_column :fee_plans, :amount, :float
  end
  
  def self.down
    remove_column :fee_plans, :event
    remove_column :fee_plans, :pay_type
    remove_column :fee_plans, :amount
  end
end
