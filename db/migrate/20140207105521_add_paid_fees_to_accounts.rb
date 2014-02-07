class AddPaidFeesToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :paid_fees, :decimal, :precision => 8, :scale => 2, :default => 0
  end
  
  def self.down
    remove_column :accounts, :paid_fees
  end
end
